defmodule Microblog.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Repo
  alias Microblog.Blog.Post
  alias Microblog.Accounts.User


  schema "posts" do
    field :content, :string
    belongs_to :author, User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> assoc_constraint(:author)
  end
end
