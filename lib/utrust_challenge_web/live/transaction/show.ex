defmodule UtrustChallengeWeb.TransactionLive.Show do
  use UtrustChallengeWeb, :live_view

  alias UtrustChallenge.BlockchainExplorer
  alias UtrustChallenge.Account.Transaction
  alias UtrustChallengeWeb.Live.Credentials
  alias UtrustChallengeWeb.Live.Presence
  alias UtrustChallenge.Account

  def mount(%{"id" => id}, session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 180_00)

    case Credentials.get_user(socket, session) do
      {:ok, user} ->
        Phoenix.PubSub.subscribe(UtrustChallenge.PubSub, "transaction:#{id}")
        {:ok, _} = Presence.track(self(), "transaction:#{id}", user.email, %{})
        {:ok, assign(socket, current_user: user)}

      {:error, _} ->
        {:ok, redirect(socket, to: "/")}

      _ ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  def handle_params(%{"id" => id}, _, socket) do
    with %Transaction{} = transaction <- Account.find_transaction(id),
         {:ok, transaction} <- BlockchainExplorer.update_local_transaction_details(transaction) do
      {:noreply,
       socket
       |> assign(:transaction, transaction)}
    else
      _ ->
        {:noreply, redirect(socket, to: "/")}
    end
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    {:ok, updated_transaction} =
      BlockchainExplorer.fetch_transaction_details(socket.assigns.transaction.tx_hash, "Ethereum")

    {:ok, transaction} =
      Account.update_transaction(
        socket.assigns.transaction,
        updated_transaction |> Map.from_struct()
      )

    Process.send_after(self(), :update, 300_001)
    {:noreply, socket |> assign(:transaction, transaction)}
  end
end
