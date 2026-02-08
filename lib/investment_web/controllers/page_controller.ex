defmodule InvestmentWeb.PageController do
  use InvestmentWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
