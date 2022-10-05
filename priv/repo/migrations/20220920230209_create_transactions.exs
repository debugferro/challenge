defmodule UtrustChallenge.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :tx_hash, :string
      add :confirmed_blocks, :string
      add :status, :string
      add :currency, :string
      add :value, :string
      add :date, :string
      add :status_msg, :string

      timestamps()
    end
  end
end
