defmodule MicroblogWeb.FollowController do
  use MicroblogWeb, :controller

  alias Microblog.Blog
  alias Microblog.Blog.Follow

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

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)

    if user_id do
      posts = Blog.followed_posts_for_id(user_id)
    else
      posts = Blog.list_posts()
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
