defmodule Addict.Utils do
  def app_name(conn) do
    conn.private.phoenix_endpoint.config(:otp_app)
    |> to_string
    |> Mix.Utils.camelize
  end

  def app_module do
    Mix.Project.config()[:app]
    |> Atom.to_string
    |> Mix.Utils.camelize
  end
end