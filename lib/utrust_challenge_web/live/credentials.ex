defmodule UtrustChallengeWeb.Live.Credentials do
  @moduledoc "Authentication helper functions"

  alias UtrustChallenge.Identity.User
  alias Phoenix.LiveView.Socket
  alias Pow.Store.CredentialsCache

  def get_user(socket, session, config \\ [otp_app: :utrust_challenge])
  def get_user(socket, %{"utrust_challenge_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
         {user, _metadata} <- CredentialsCache.get([backend: Pow.Store.Backend.EtsCache], token) do
      {:ok, user}
    else
      _any -> {:error, :not_authenticated}
    end
  end

  def get_user(_, _, _), do: nil
end
