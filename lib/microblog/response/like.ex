defmodule Microblog.Response.Like do
  use Ecto.Schema
  import Ecto.Changeset

  alias Microblog.Response.Like
  alias Microblog.Blog.Post
  alias Microblog.Accoutns.User

  @primary_key false
  schema "likes" do
    belongs_to :post, Post, primary_key: true
    belongs_to :user, User, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(%Like{} = like, attrs) do
    like
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:user)
  end
end
