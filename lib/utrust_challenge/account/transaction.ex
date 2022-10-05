defmodule UtrustChallenge.Account.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias UtrustChallenge.Account.{Subscription, StatusDetails}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "transactions" do
    field :confirmed_blocks, :string
    field :status, Ecto.Enum, values: [:confirmed, :pending]
    field :tx_hash, :string
    field :value, :string
    field :date, :string
    field :currency, Ecto.Enum, values: [ethereum: "Ethereum"]
    field :status_msg, :string

    has_many :subscriptions, Subscription
    has_many :users, through: [:subscriptions, :users]
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs \\ %{}) do
    transaction
    |> cast(attributes(attrs), [:tx_hash, :confirmed_blocks, :status, :value, :currency, :status_msg])
    |> validate_required([:tx_hash, :confirmed_blocks, :status, :value, :currency, :status_msg])
  end

  defp attributes(%{status_msg: _status} = attrs) do
    attrs
    |> Map.put(:status, status(attrs))
  end

  defp attributes(attrs), do: attrs

  defp status(%{confirmed_blocks: confirmed_blocks, result: result} = transaction) do
    {confirmed_blocks, _} = Integer.parse(confirmed_blocks)
    case confirmed_blocks >= 2 && result.is_error == "0" && transaction.status_msg == "Success" do
      true -> :confirmed
      false -> :pending
    end
  end

  def currencie_values do
    Ecto.Enum.values(__MODULE__, :currency) ++ Ecto.Enum.dump_values(__MODULE__, :currency)
  end
end
