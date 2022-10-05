defmodule UtrustChallengeWeb.ControllerCallbacks do
  use Pow.Extension.Phoenix.ControllerCallbacks.Base
  use UtrustChallengeWeb, :controller

  def before_respond(Pow.Phoenix.SessionController, :create, {:ok, conn}, _config) do
    UtrustChallengeWeb.Endpoint.broadcast(
      "users_socket:#{conn.assigns.current_user.id}",
      "disconnect",
      %{}
    )

    {:ok,
     conn
     |> put_session(:live_socket_id, "user_socket:#{conn.assigns.current_user.id}")
     |> put_session(:current_user_id, conn.assigns.current_user.id)}
  end
end
