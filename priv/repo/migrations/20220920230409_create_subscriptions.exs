defmodule UtrustChallenge.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :user_id, references(:users, on_delete: :nothing)
      add :transaction_id, references(:transactions, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:subscriptions, [:user_id, :transaction_id], name: :user_id_transaction_id)
  end
end
