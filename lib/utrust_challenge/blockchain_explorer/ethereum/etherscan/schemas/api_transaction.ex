defmodule UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan.Schemas.ApiTransaction do
  alias __MODULE__

  defstruct [:status, :message, result: [:is_error, :err_description]]

  def parse(payload) do
    %ApiTransaction{
      status: payload["status"],
      message: payload["message"],
      result: %{
        is_error: payload["result"]["isError"],
        err_description: payload["result"]["errDescription"]
      }
    }
  end
end
