defmodule UtrustChallengeWeb.TransactionControllerTest do
  use ExUnit.Case, async: false
  use UtrustChallengeWeb.ConnCase

  alias UtrustChallenge.Repo
  alias UtrustChallenge.Account.{Transaction, Subscription}

  @opts UtrustChallenge.Test.MockServers.EtherscanServer.init([])

  @transaction_attrs %{"transaction" => %{"tx_hash" => "0xda0ab8eb0dfcc91be5ca7e6b0c2bbe8cf80694fee0b3ea6b9b0bc9381418c9ec", "currency" => "Ethereum"}}

  setup %{conn: conn} do
    {:ok, user} = Repo.insert(%UtrustChallenge.Identity.User{email: "teste@hotmail.com", password: "12345678"})
    authed_conn = Pow.Plug.assign_current_user(conn, user, [])

    {:ok, conn: conn, authed_conn: authed_conn}
  end

  test "CREATE /transaction", %{authed_conn: conn} do
    conn = post(conn, Routes.transaction_path(conn, :create), @transaction_attrs)
    subscription = Repo.all(Subscription) |> List.last() |> Repo.preload([:transaction, :user])
    transaction = subscription.transaction
    assert subscription.user.id == conn.assigns.current_user.id
    assert transaction.tx_hash == @transaction_attrs["transaction"]["tx_hash"]
    assert transaction.currency == :ethereum
    assert transaction.status_msg == "Success"
    assert transaction.value == "400 ETH"
    assert transaction.confirmed_blocks == "500"
    assert transaction.status == :confirmed
    assert assert redirected_to(conn) =~ Routes.transaction_show_path(conn, :show, transaction.id)
  end
end
