defmodule UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan.Schemas.ApiTransaction do
  alias __MODULE__

  defstruct [:status, :message, result: [:is_error, :err_description]]

  def parse(%{"status" => _, "message" => "OK"} = payload) do
    {:ok, %ApiTransaction{
      status: payload["status"],
      message: payload["message"],
      result: %{
        is_error: payload["result"]["isError"],
        err_description: payload["result"]["errDescription"]
      }
    }}
  end

  def parse(%{"message" => "NOTOK", "result" => result_msg}), do: {:error, result_msg}
  def parse(_), do: {:error, "Unexpected error"}
end
