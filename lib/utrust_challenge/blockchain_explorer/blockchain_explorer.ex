defmodule UtrustChallenge.BlockchainExplorer do
  @moduledoc """
    Get data for any supported crypto currency
  """
  alias UtrustChallenge.{Account, Account.Transaction}

  @adapters Application.get_env(:utrust_challenge, UtrustChallenge.BlockchainExplorer.Adapter)
  @currencies Transaction.currencie_values()

  def fetch_transaction_details(tx_hash, currency) when currency in @currencies do
    adapter(currency).fetch_transaction(tx_hash)
  end

  def fetch_transaction_details(_, cur), do: {:error, "This currency is not supported"}

  def update_local_transaction_details(transaction) do
    if Timex.diff(Timex.now, transaction.updated_at, :minutes) >= 2 do
      do_update_local_transaction_details(transaction)
    else
      {:ok, transaction}
    end
  end

  defp do_update_local_transaction_details(transaction) do
    fetch_transaction_details(transaction.tx_hash, transaction.currency)
    |> case do
      {:ok, updated_transaction_attrs} ->
        updated_transaction_attrs = Map.from_struct(updated_transaction_attrs)
        Account.update_transaction(transaction, updated_transaction_attrs)

      error ->
        error
    end
  end

  defp adapter(adapter) when adapter in [:ethereum, "Ethereum"], do: @adapters[:ethereum_adapter]
end
