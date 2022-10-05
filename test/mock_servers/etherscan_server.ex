defmodule UtrustChallenge.Test.MockServers.EtherscanServer do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason

  plug :match
  plug :dispatch

  get "/tx/:txhash" do
    body =
      case conn.params do
        %{"txhash" => "1234"} ->
          txhash_page_html(%{block_confirmations: 1, status: "Transaction Failed", value: "40"})

        %{"txhash" => txhash} ->
          txhash_page_html(%{block_confirmations: 500, status: "Success", value: "400"})
      end

    success(conn, :html, body)
  end

  get "/api" do
    case conn.params do
      %{"action" => "getstatus", "apikey" => _, "module" => "transaction", "txhash" => tx_hash} ->
        success(conn, :json, %{
          status: "1",
          message: "OK",
          result: %{isError: "0", errDescription: ""}
        })

      _ ->
        failure(conn, "Failed")
    end
  end

  defp success(conn, type, body \\ "")

  defp success(conn, :json, body) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(200, Jason.encode!(body))
  end

  defp success(conn, :html, body) do
    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, body)
  end

  defp failure(conn, error) do
    conn
    |> Plug.Conn.send_resp(422, Jason.encode!(error))
  end

  defp txhash_page_html(data) do
    """
      <html>
        <body>
          <p title="Number of blocks mined since">#{data.block_confirmations} Block Confirmations</p>
          <p title="A Status code indicating if the top-level call succeeded or failed (applicable for Post BYZANTIUM blocks only)">#{data.status}</p>
          <p title="The amount of ETH to be transferred to the recipient with the transaction">#{data.value} ETH</p>
          <p id="ContentPlaceHolder1_divTimeStamp">13 secs ago (Oct-05-2022 04:13:59 PM +UTC)</p>
        </body>
      </html>
    """
  end
end
