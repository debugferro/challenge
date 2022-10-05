defmodule UtrustChallenge.Account.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "subscriptions" do
    belongs_to :user, UtrustChallenge.Identity.User, type: :binary_id
    belongs_to :transaction, UtrustChallenge.Account.Transaction, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:user_id, :transaction_id])
    |> validate_required([:user_id, :transaction_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:transaction_id)
    |> unique_constraint(:user, name: :user_id_transaction_id, error_key: :user, message: "already processed this payment")
  end
end
