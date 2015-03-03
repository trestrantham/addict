defmodule ExampleApp.Router do
  use Phoenix.Router
  use Addict.RoutesHelper

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    get "/", ExampleApp.PageController, :index
    get "/show", ExampleApp.PageController, :show
    get "/forbidden", ExampleApp.PageController, :forbidden

    addict :routes,
      register: [layout: false, view: MyApp.MyView],
      login: [layout: {MyApp.MyLayout, "some_template.html"}],
      logout: [path: "/logout", controller: ExampleApp.UserController, action: :signout],
      recover_password: "/password/recover",
      reset_password: "/password/reset"
  end
end
