defmodule UtrustChallengeWeb.PageController do
  use UtrustChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
