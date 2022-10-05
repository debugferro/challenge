defmodule UtrustChallenge.BlockchainExplorer.Ethereum.EtherscanApi do
  @moduledoc """
    Etherscan API module
  """
  use Tesla

  alias __MODULE__
  alias UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan.Schemas.ApiTransaction

  @app_env Application.get_env(:utrust_challenge, Etherscan)
  @base_url @app_env[:base_api_url]
  @api_key @app_env[:api_key]

  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.Query, [apikey: @api_key]
  plug Tesla.Middleware.JSON

  def check_contract_execution_status(tx_hash) do
    get("/", query: [module: "transaction", action: "getstatus", txhash: tx_hash])
    |> format_response(200, ApiTransaction)
  end

  defp format_response({:ok, %Tesla.Env{status: status, body: body}}, expected_http_code, struct) do
    case status do
      ^expected_http_code -> {:ok, struct.parse(body)}
      _ -> {:error, body}
    end
  end
end
