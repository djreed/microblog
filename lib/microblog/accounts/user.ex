defmodule Microblog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Microblog.Accounts
  alias Microblog.Accounts.User
  alias Microblog.Blog.Post
  alias Microblog.Blog.Follow

  schema "users" do
    field :email, :string
    field :name, :string
    field :handle, :string
    field :description, :string

    field :is_admin?, :boolean

    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

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
    |> cast(attrs, [:name, :handle, :description, :email, :is_admin?, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
    |> unique_constraint(:email)
    |> unique_constraint(:handle)
    |> validate_required([:email, :handle, :password_hash])
  end

  # Nat Tuck Lecture Code

  # Password validation
  # From Comeonin docs
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
                                     %{password: password}} = changeset) do
    change(changeset, Comeonin.Pbkdf2.add_hash(password))
  end
  defp put_pass_hash(changeset), do: changeset

  defp valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end
  defp valid_password?(_), do: {:error, "The password is too short"}

  def update_tries(throttle, prev) do
    if throttle do
      prev + 1
    else
      1
    end
  end

  def throttle_attempts(user) do
    y2k = DateTime.from_naive!(~N[2000-01-01 00:00:00], "Etc/UTC")
    prv = DateTime.to_unix(user.pw_last_try || y2k)
    now = DateTime.to_unix(DateTime.utc_now())
    thr = (now - prv) < 3600

    if (thr && user.pw_tries > 5) do
      nil
    else
      changes = %{
        pw_tries: update_tries(thr, user.pw_tries),
        pw_last_try: DateTime.utc_now(),
      }
      IO.inspect(user)
      {:ok, user} = Ecto.Changeset.cast(user, changes, [:pw_tries, :pw_last_try])
      |> Microblog.Repo.update
      user
    end
  end
  # End of Nat Tuck's Code


  def get_and_auth_user(login, password) do
    if login && password do

      user = Accounts.get_user_by_email(login)
      if user do
        case Comeonin.Pbkdf2.check_pass(user, password) do
          {:ok, user} -> user
          _else       -> nil
        end
      end

      user = Accounts.get_user_by_handle(login)

      case Comeonin.Pbkdf2.check_pass(user, password) do
        {:ok, user} -> user
        _else       -> nil
      end
    end
  end

end
