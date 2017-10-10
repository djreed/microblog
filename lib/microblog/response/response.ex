defmodule Microblog.Response do
  @moduledoc """
  The Response context.
  """

  import Ecto.Query, warn: false
  alias Microblog.Repo

  alias Microblog.Response.Like

  alias Microblog.Accounts.User

  @doc """
  Returns the list of likes.

  ## Examples

      iex> list_likes()
      [%Like{}, ...]

  """
  def list_likes do
    Repo.all(Like)
  end

  @doc """
  Gets a single like.

  Raises `Ecto.NoResultsError` if the Like does not exist.

  ## Examples

      iex> get_like!(123)
      %Like{}

      iex> get_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_like!(id), do: Repo.get!(Like, id)

  @doc """
  Creates a like.

  ## Examples

      iex> create_like(%{field: value})
      {:ok, %Like{}}

      iex> create_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_like(attrs \\ %{}) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  def likes_for_post(post_id) do
    query = from l in Like,
      where: l.post_id == ^post_id
    Repo.all(query)
  end

  def find_like(u_id, p_id) do
    query = from l in Like,
      where: l.post_id == ^p_id and l.user_id == ^u_id
    Repo.one(query)
  end


  @doc """
  Returns all Users who have liked this post

  ## Examples

  iex> get_followed_users_for_id(1)
  [%User{}]

  """
  def get_user_likes(p_id) do
    query = from u in User,
      join: l in Like,
      on: l.post_id == ^p_id and l.user_id == u.id,
      select: u
    Repo.all(query)
  end

  @doc """
  Returns all Users who have liked this post

  ## Examples

  iex> get_followed_users_for_id(1)
  [%User{}]

  """
  def get_user_like_count(p_id) do
    query = from u in User,
      join: l in Like,
      on: l.post_id == ^p_id and l.user_id == u.id,
      select: u
    Repo.all(query)
    |> length()
  end

  @doc """
  Updates a like.

  ## Examples

      iex> update_like(like, %{field: new_value})
      {:ok, %Like{}}

      iex> update_like(like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_like(%Like{} = like, attrs) do
    like
    |> Like.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Like.

  ## Examples

      iex> delete_like(like)
      {:ok, %Like{}}

      iex> delete_like(like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking like changes.

  ## Examples

      iex> change_like(like)
      %Ecto.Changeset{source: %Like{}}

  """
  def change_like(%Like{} = like) do
    Like.changeset(like, %{})
  end
end
