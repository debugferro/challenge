defmodule UtrustChallengeWeb.Live.Presence do
  use Phoenix.Presence,
    otp_app: :utrust_challenge,
    pubsub_server: UtrustChallenge.PubSub
end
