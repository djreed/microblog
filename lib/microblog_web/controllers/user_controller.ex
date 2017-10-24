defmodule MicroblogWeb.UserController do
  use MicroblogWeb, :controller

  alias Microblog.Repo
  alias Microblog.Accounts
  alias Microblog.Accounts.User
  alias Microblog.Blog

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    |> Repo.preload([:posts, [posts: :author]])

    user_id = get_session(conn, :user_id)

    follow =
    if user_id do
      Blog.get_follow(user_id, user.id)
    else
      nil
    end

    render(conn, "show.html",
      user: user,
      following: follow != nil,
      posts: Enum.reverse(user.posts))
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cuid = get_session(conn, :user_id)

    if !cuid do
      conn
      |> put_flash(:error, "You must log in to delete a user")
      |> redirect(to: user_path(conn, :index))
    else
      if Accounts.get_user(cuid).is_admin? do
        conn
        |> put_flash(:error, "You must log in as an admin to delete a user")
        |> redirect(to: user_path(conn, :index))
      else
        user = Accounts.get_user!(id)
        {:ok, _user} = Accounts.delete_user(user)

        conn
        |> put_flash(:info, "User deleted successfully.")
        |> redirect(to: user_path(conn, :index))
      end
    end
  end
end
