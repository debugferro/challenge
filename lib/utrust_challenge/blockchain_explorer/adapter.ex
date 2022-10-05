defmodule UtrustChallenge.BlockchainExplorer.Adapter do
  @doc """
    Fetch external data for a transaction by tx_hash
  """
  @callback fetch_transaction(String.t) :: {:ok, struct} | {:error, atom}
end
