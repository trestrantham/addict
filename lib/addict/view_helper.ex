defmodule Addict.ViewHelper do
  @moduledoc """
  Addict helper view functions to be used on templates
  """

  # The quoted expression returned by this block is applied
  # to this module and all other views that use this module.
  defmacro __using__(_) do
    quote do
      import Plug.Conn

      @doc """
      Checks if user is logged in, returns true if so,
      and false if not
      """
      def logged_in(conn) do
        !!get_session conn, :current_user
      end

      @doc """
      Gets user model properties
      """
      def get_user(conn, prop) do
        user = get_session conn, :current_user
        user_prop(user, prop)
      end

      defp user_prop(nil, _) do
        nil
      end

      defp user_prop(user, prop) do
        Map.get user, prop
      end
    end
  end
end
