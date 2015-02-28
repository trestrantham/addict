defmodule Addict.AddictController do
  @moduledoc """
   Default controller used by Addict
   """
  use Phoenix.Controller
  plug :action
  plug :render
  use Addict.BaseController
end
