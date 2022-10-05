defmodule UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan.Schemas.Transaction do
  alias __MODULE__

  defstruct [:value, :tx_hash, :date, :confirmed_blocks, :status_msg, :currency, result: [:is_error, :err_description]]

  def parse(data, scrapped_data) do
    %Transaction{
      tx_hash: data.tx_hash,
      confirmed_blocks: scrapped_data.confirmed_blocks,
      value: scrapped_data.value,
      date: scrapped_data.date,
      status_msg: scrapped_data.status_msg,
      result: data.result,
      currency: :ethereum
    }
  end
end
