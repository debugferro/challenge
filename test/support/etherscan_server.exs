defmodule UtrustChallenge.Test.Support.EtherscanServer do
  # use Plug.Router
  # plug Plug.Parsers, parsers: [:json],
  #                   pass:  ["text/*"],
  #                   json_decoder: Poison

  # plug :match
  # plug :dispatch

  # get "/api" do
  #   success(conn, %{"teste" => "10"})
  # end

  # defp success(conn, body \\ "") do
  #   conn
  #   |> Plug.Conn.send_resp(200, Poison.encode!(body))
  # end

  def transaction()
    %{"status" => "1","message" => "OK","result" =>  %{"isError" => "0","errDescription" => ""}}
  end
end
