defmodule UtrustChallenge.Account do
  @doc """
    Account context
  """
  import Ecto.Query
  alias UtrustChallenge.Account.{Subscription, Transaction}
  alias UtrustChallenge.Repo

  def update_or_create_transaction({:ok, transaction_data}, user_id) do
    transaction_data = Map.from_struct(transaction_data)

    transaction =
      case Repo.one(from t in Transaction, where: t.tx_hash == ^transaction_data.tx_hash) do
        nil -> %Transaction{}
        transaction -> transaction
      end
      |> Transaction.changeset(transaction_data)

    Ecto.Multi.new()
    |> Ecto.Multi.insert_or_update(:transaction, transaction)
    |> Ecto.Multi.insert_or_update(:subscription, fn %{transaction: transaction} ->
      Subscription.changeset(%Subscription{}, %{
        user_id: user_id,
        transaction_id: transaction.id
      })
    end)
    |> UtrustChallenge.Repo.transaction()
  end

  def update_or_create_transaction(result, _user_id), do: result

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def update_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  def find_transaction(id) do
    Repo.get(Transaction, id)
  end

  def list_transactions(user) do
    Repo.all(
      from t in Transaction,
        join: s in assoc(t, :subscriptions),
        on: s.user_id == ^user.id,
        select: t,
        order_by: t.inserted_at
    )
  end

  defp build_subscription_attrs({:ok, transaction}, user_id) do
    %{
      user_id: user_id,
      transaction_id: transaction.id
    }
  end

  defp build_subscription_attrs(_, _), do: %{}
end
