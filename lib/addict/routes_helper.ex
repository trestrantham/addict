defmodule Addict.RoutesHelper do
  defmacro __using__(_) do
    quote do
      import Addict.RoutesHelper
    end
  end

  defmacro addict(:routes, options \\ %{}) do
    routes = [:register, :login, :logout, :recover_password, :reset_password]

    for route <- routes do
      route_options = options_for_route(route, options[route])

      quote do
        get unquote(route_options[:path]),
          Addict.AddictController,
          unquote(route),
          as: unquote(route)

        post unquote(route_options[:path]),
          unquote(route_options[:controller]),
          unquote(route_options[:action]),
          as: unquote(route_options[:as])
      end
    end
  end

  defp options_for_route(route, options) when is_list(options) do
    path       = route_path(route, options[:path])
    controller = options[:controller] || Addict.AddictController
    action     = options[:action] || route
    as         = route

    post_action = "process_#{to_string(action)}" |> String.to_atom

    %{path: path, controller: controller, action: post_action, as: as}
  end
  defp options_for_route(route, path) do
    options_for_route(route, [path: route_path(route, path)])
  end

  defp route_path(route, path) do
    path || "/#{to_string(route)}"
  end
end
