defmodule Microblog.Repo.Migrations.UserDescription do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :description, :text
    end
  end

end
