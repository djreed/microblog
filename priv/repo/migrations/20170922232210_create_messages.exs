defmodule Microblog.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :title, :string
      add :content, :text
      add :author, :string

      timestamps()
    end

  end
end
