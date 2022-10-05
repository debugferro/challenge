defmodule UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan do
  @moduledoc """
    Etherscan data fetching module (API + SCRAPER)
  """
  alias UtrustChallenge.BlockchainExplorer.Ethereum.EtherscanApi

  alias UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan.{
    Schemas.Transaction,
    Scraper.TransactionPage
  }

  alias UtrustChallenge.BlockchainExplorer.Adapter

  @behaviour Adapter

  def fetch_transaction(tx_hash) do
    with {:ok, transaction} <- EtherscanApi.check_contract_execution_status(tx_hash),
         {:ok, transaction_scrapped_details} <- TransactionPage.fetch(tx_hash) do
      {:ok,
       transaction
       |> Map.put(:tx_hash, tx_hash)
       |> Transaction.parse(transaction_scrapped_details)}
    else
      error -> error
    end
  end
end
