defmodule Microblog.Blog.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  alias Microblog.Blog.Follow
  alias Microblog.Accounts.User

  @primary_key false
  schema "follows" do
    belongs_to :user, User, primary_key: true
    belongs_to :follow, User, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(%Follow{} = follow, attrs) do
    follow
    |> cast(attrs, [:user_id, :follow_id])
    |> validate_required([:user_id, :follow_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:follow)
  end
end
