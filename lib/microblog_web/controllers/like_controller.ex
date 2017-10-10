defmodule MicroblogWeb.LikeController do
  use MicroblogWeb, :controller

  alias Microblog.Response
  alias Microblog.Response.Like

  action_fallback MicroblogWeb.FallbackController

  def index(conn, _params) do
    likes = Response.list_likes()
    render(conn, "index.json", likes: likes)
  end

  def create(conn, %{"like" => like_params}) do
    existing = Response.find_like(
      like_params["user_id"], like_params["post_id"]
    )

    if (is_nil(existing)) do
      with {:ok, %Like{} = like} <- Response.create_like(like_params) do
        likes = Response.likes_for_post(like.post_id)
        conn
        |> put_status(:created)
        |> put_resp_header("location", like_path(conn, :show, like.post_id))
        |> render("show.json", like: like)
      end
    else
      conn
      |> render("show.json", like: nil)
    end
  end

  def show(conn, %{"id" => id}) do
    likes = Response.likes_for_post(id)
    render(conn, "show.json", likes: likes)
  end

#  def update(conn, %{"id" => id, "like" => like_params}) do
#    like = Response.get_like!(id)

#    with {:ok, %Like{} = like} <- Response.update_like(like, like_params) do
#      render(conn, "show.json", like: like)
#    end
#  end


  def delete(conn, %{"id" => id}) do
    like = Response.get_like!(id)
    with {:ok, %Like{}} <- Response.delete_like(like) do
      send_resp(conn, :no_content, "")
    end
  end
end
