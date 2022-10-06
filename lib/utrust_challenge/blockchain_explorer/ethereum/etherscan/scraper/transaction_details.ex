defmodule UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan.Scraper.TransactionPage do
  @moduledoc """
    Transaction page scraper for Etherscan
  """
  @base_url Application.compile_env(:utrust_challenge, Etherscan)[:base_url]

  def fetch(tx_hash) do
    Crawly.fetch("#{@base_url}/tx/#{tx_hash}")
    |> parse_item()
  end

  defp parse_item(response) do
    with {:ok, document} <- Floki.parse_document(response.body),
         confirmed_blocks <- get_block_confirmations(document),
         {:ok, date} <- get_date(document),
         status <- get_status(document),
         value <- get_value(document) do
      {:ok,
       %{
         confirmed_blocks: confirmed_blocks,
         value: value,
         status_msg: status,
         date: date
       }}
    else
      :not_found -> {:error, :not_found_values}
    end
  end

  defp get_block_confirmations(document) do
    document
    |> Floki.find("[title=\'Number of blocks mined since\']")
    |> Floki.text()
    |> String.split(" ")
    |> List.first()
  end

  defp get_status(document) do
    document
    |> Floki.find(
      "[title=\'A Status code indicating if the top-level call succeeded or failed (applicable for Post BYZANTIUM blocks only)\']"
    )
    |> Floki.text()
  end

  defp get_value(document) do
    document
    |> Floki.find(
      "[title=\'The amount of ETH to be transferred to the recipient with the transaction\']"
    )
    |> Floki.text()
  end

  defp get_date(document) do
    document
    |> Floki.find("#ContentPlaceHolder1_divTimeStamp")
    |> Floki.text()
    |> String.split(["(", ")"])
    |> case do
      [_, date, _] -> {:ok, date}
      _ -> :not_found
    end
  end
end
