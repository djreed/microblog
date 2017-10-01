defmodule Microblog.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :follow_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:follows, [:user_id])
    create index(:follows, [:follow_id])
  end
end
