defmodule Addict.BaseController do
  @moduledoc """
    Addict BaseController is used as a base to be extended by controllers if needed.
    BaseController has functions to receive User related requests directly from
    the Phoenix router.  Adds `register/2`, `logout/2` and `login/2` as public functions.
   """

  defmacro __using__(_) do
    quote do
      @manager Application.get_env(:addict, :manager) || Addict.ManagerInteractor
      alias Addict.SessionInteractor
      alias Addict.Utils

      @doc """
      GET paths for register, login, password recovery, and password reset
      """
      def register(conn, _params), do: render_action(conn)
      def login(conn, _params), do: render_action(conn)
      def recover_password(conn, _params), do: render_action(conn)
      def reset_password(conn, _params), do: render_action(conn)

      defp render_action(conn) do
        addict = conn.private.addict

        layout = case addict.layout do
          false ->
            false
          nil ->
            {Module.concat([Utils.app_name(conn), LayoutView]), "application.html"}
          _ ->
            addict.layout
        end
        view = addict.view || Module.concat([Utils.app_name(conn), AddictView])

        conn
        |> put_layout(layout)
        |> put_view(view)
      end

      @doc """
      Entry point for registering new users.

      `params` needs to include email, password and username.
      Returns a JSON response in the format `{message: text, user: %User{}}` with status `201` for
      successful creation, or `400` for when an error occurs.
      On success, it also logs the new user in.
      """
      def process_register(conn, params) do
        {conn, message} = @manager.create(params)
        |> SessionInteractor.register(conn)
        json conn, message
      end

      # @doc """
      #   Entry point for logging out users.

      #   Since it only deletes session data, it should always return a JSON response
      #   in the format `{message: "logged out"}` with a `200` status code.
      #  """
      # def logout(conn, _) do
      #   {conn, message} = SessionInteractor.logout(conn)
      #   json conn, message
      # end

      # @doc """
      #   Entry point for logging users in.

      #   Params needs to be populated with `email` and `password`. It returns `200`
      #   status code along with the JSON response `{message: "logged in", user: %User{}` or `400`
      #   with `{message: "invalid email or password"}`

      #  """
      # def login(conn, params) do
      #   email = params["email"]
      #   password = params["password"]

      #   {conn, message} = @manager.verify_password(email, password)
      #   |> SessionInteractor.login(conn)
      #   json conn, message
      # end

      # @doc """
      #  Entry point for asking for a new password.

      #  Params need to be populated with `email`
      # """
      # def recover_password(conn, params) do
      #   email = params["email"]

      #   {conn, message} = @manager.recover_password(email)
      #   |> SessionInteractor.password_recover(conn)
      #   json conn, message
      # end

      # @doc """
      #  Entry point for setting a user's password given the reset token.

      #  Params needed to be populated with `token`, `password` and `password_confirm`
      # """
      # def reset_password(conn, params) do
      #   token = params["token"]
      #   password = params["password"]
      #   password_confirm = params["password_confirm"]

      #   {conn, message} = @manager.reset_password(token, password, password_confirm)
      #   |> SessionInteractor.password_reset(conn)
      #   json conn, message
      # end

      defoverridable Module.definitions_in(__MODULE__)
    end
  end
end
