defmodule Microblog.Repo.Migrations.UserHandle do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :handle, :string, null: false
    end

    create unique_index(:users, [:handle])
  end

end
