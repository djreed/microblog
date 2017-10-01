defmodule Microblog.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false
      add :handle, :string, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:handle])
  end

end
