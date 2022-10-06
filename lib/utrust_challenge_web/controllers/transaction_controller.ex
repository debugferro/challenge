defmodule UtrustChallengeWeb.TransactionController do
  use UtrustChallengeWeb, :controller

  alias UtrustChallenge.{Account, Account.Transaction}
  alias UtrustChallenge.BlockchainExplorer
  alias UtrustChallenge.Helpers

  @transaction_changeset Transaction.changeset(%Transaction{})

  def index(conn, _params) do
    current_user = Pow.Plug.current_user(conn)
    transactions = Account.list_transactions(current_user)
    render(conn, "index.html", transactions: transactions, current_user: current_user)
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: @transaction_changeset)
  end

  def create(conn, %{"transaction" => %{"currency" => currency, "tx_hash" => tx_hash}}) do
    BlockchainExplorer.fetch_transaction_details(tx_hash, currency)
    |> Account.update_or_create_transaction(Pow.Plug.current_user(conn).id)
    |> case do
      {:ok, subscription} ->
        redirect(conn, to: Routes.transaction_show_path(conn, :show, subscription.transaction.id))
      {:error, _, subscription, transaction} ->
        conn
        |> put_flash(:error, Helpers.changeset_errors(subscription) <> Helpers.changeset_errors(transaction))
        |> render("new.html", changeset: @transaction_changeset)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("new.html", changeset: @transaction_changeset)
    end
  end
end
