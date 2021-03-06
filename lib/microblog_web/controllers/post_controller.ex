defmodule MicroblogWeb.PostController do
  use MicroblogWeb, :controller

  alias Microblog.Accounts
  alias Microblog.Blog
  alias Microblog.Blog.Post

  def index(conn, _params) do
      posts = Blog.list_posts()

      render(conn, "index.html", posts: Enum.reverse(posts))
  end

  def new(conn, _params) do
    cuid = get_session(conn, :user_id)
    if !cuid do
      conn
      |> put_flash(:error, "You must log in to create a post")
      |> redirect(to: user_path(conn, :index))
    else
      changeset = Blog.change_post(%Post{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"post" => post_params}) do
    post_params = Map.put(post_params, "user_id", get_session(conn, :user_id))

    case Blog.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: user_path(conn, :show, post.user_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
      post = Blog.get_post!(id)
      render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    changeset = Blog.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    cuid = get_session(conn, :user_id)
    if !cuid do
      conn
      |> put_flash(:error, "You must log in to update a post")
      |> redirect(to: user_path(conn, :index))
    else
      post = Blog.get_post!(id)

      case Blog.update_post(post, post_params) do
        {:ok, _post} ->
          conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", post: post, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    cuid = get_session(conn, :user_id)
    if !cuid do
      conn
      |> put_flash(:error, "You must log in to update a post")
      |> redirect(to: user_path(conn, :index))
    else
      post = Blog.get_post!(id)

      cur_user = Accounts.get_user!(cuid)

      if cur_user.is_admin? || post.user_id == cur_user.id do
        {:ok, _post} = Blog.delete_post(post)
        conn
        |> put_flash(:info, "Post deleted successfully.")
        |> redirect(to: post_path(conn, :index))
      else
        conn
        |> put_flash(:error, "Cannot delete another user's post.")
        |> redirect(to: user_path(conn, :index))
      end
    end
  end
end
