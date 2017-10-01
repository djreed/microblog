defmodule Microblog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Accounts.User
  alias Microblog.Blog.Post
  alias Microblog.Blog.Follow

  schema "users" do
    field :email, :string
    field :name, :string
    field :handle, :string
    field :description, :string

    has_many :posts, Post,
      foreign_key: :user_id,
      on_delete: :delete_all

    many_to_many :follows, User, join_through: Follow,
      join_keys: [user_id: :id, follow_id: :id],
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :handle, :description])
    |> validate_required([:email, :handle])
    |> unique_constraint(:email)
    |> unique_constraint(:handle)
  end
end
