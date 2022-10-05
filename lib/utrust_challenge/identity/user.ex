defmodule UtrustChallenge.Identity.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  alias UtrustChallenge.Account.Subscription

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    pow_user_fields()

    has_many :subscriptions, Subscription
    timestamps()
  end
end
