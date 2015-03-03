defmodule Mix.Tasks.Addict.Gen.Templates do
  use Mix.Task
  import Mix.Generator
  alias Addict.Utils

  @shortdoc "Generate templates and view for Addict"
  @moduledoc """
  Generates an Addict view and templates
      mix addict.gen.templates
  """
  def run(opts) do
    bindings = [
      module: Module.concat(Utils.app_module, AddictView),
      view: Module.concat(Utils.app_module, View)
    ]

    view_file = Path.join(["web", "views", "addict_view.ex"])
                |> Path.relative_to(Mix.Project.app_path)
    create_file view_file, view_template(bindings)

    create_file Path.join(["web", "templates", "addict", "login.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                login_text

    create_file Path.join(["web", "templates", "addict", "recover_password.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                recover_password_text

    create_file Path.join(["web", "templates", "addict", "register.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                register_text

    create_file Path.join(["web", "templates", "addict", "reset_password.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                reset_password_text
  end

  embed_template :view, """
  defmodule <%= inspect @module %> do
    use <%= inspect @view %>
    use Addict.ViewHelper
  end
  """

  embed_text :login, from_file("../../addict/templates/addict/login.html.eex")
  embed_text :recover_password, from_file("../../addict/templates/addict/recover_password.html.eex")
  embed_text :register, from_file("../../addict/templates/addict/register.html.eex")
  embed_text :reset_password, from_file("../../addict/templates/addict/reset_password.html.eex")
end
