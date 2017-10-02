defmodule MicroblogWeb.FollowController do
  use MicroblogWeb, :controller
  alias Microblog.Blog
  alias Microblog.Accounts

  def follow(conn, follow_params) do
    if Blog.get_follow(follow_params["user_id"], follow_params["follow_id"]) do
        conn
        |> put_flash(:info, "You are already following this user")
        |> redirect(to: user_path(conn, :show, follow_params["follow_id"]))
    else
      case Blog.create_follow(follow_params) do
        {:ok, follow} ->
          conn
          |> put_flash(:info, "Now following this user.")
          |> redirect(to: user_path(conn, :show, follow_params["follow_id"]))
        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> redirect(to: user_path(conn, :show, follow_params["follow_id"]))
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)

    if user == nil do
      conn
      |> put_flash(:error, "No such user found")
      |> redirect(to: user_path(conn, :index))
    end

    follows = Blog.get_followed_users_for_id(id)

    render(conn, "show.html", user: user, follows: follows)
  end

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)

    if user_id == nil do
      conn
      |> put_flash(:error, "You must be logged in to access follows")
      |> redirect(to: user_path(conn, :index))
    end

    posts =
    if user_id do
      Blog.followed_posts_for_id(user_id)
    else
      Blog.list_posts()
    end

    render(conn, "index.html", posts: posts)
  end

  def unfollow(conn, follow_params) do
    follow = Blog.get_follow(follow_params["user_id"], follow_params["follow_id"])
    if follow do
      {:ok, _follow} = Blog.delete_follow(follow)

      conn
      |> put_flash(:info, "No longer following this user.")
      |> redirect(to: user_path(conn, :show, follow_params["follow_id"]))
    end
  end
end
