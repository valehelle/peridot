defmodule Peridot.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Peridot.Repo

  alias Peridot.Jobs.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def post_exists?(comment_id) do
    query = from p in Post,
            where: p.comment_id == ^comment_id

    case Repo.one(query) do
      nil -> false
      _ -> true
    end
  end

  def find_post(%{"q" => q} = params) do
    use Timex
    previous_datetime = Timex.now
                        |> Timex.shift(minutes: -40320)

    remote = Map.fetch(params, "remote") |> check_boolean()
    relocate = Map.fetch(params, "relocate") |> check_boolean()
    q = String.upcase(q)
    split_query = String.split(q, ",", trim: true)
                  |> Enum.filter(fn query -> !String.equivalent?(String.trim(query),"") end)
    filters = build_filter(split_query)
    query = from p in Post,
      where: fragment("? SIMILAR TO ?", fragment("upper(?)", p.content), ^filters),
      where: p.inserted_at >= ^previous_datetime
    
    query
      |> compose_remote(remote)
      |> compose_relocate(relocate)
      |> Repo.all()
    
  end

  def build_filter(split_query) do
    query = Enum.join(split_query, "|")
    "%(#{query})%"
  end

  def compose_remote(query, remote) do
    case remote do
      true -> where(query, [p], p.remote == true)
      _ -> query
    end
    
  end
  def compose_relocate(query, relocate) do
    case relocate do
      true -> where(query, [p], p.relocate == true)
      _ -> query
    end
  end


  defp build_query(query, criteria) do
    Enum.reduce(criteria, query, &compose_query/2)
  end
  
  defp compose_query(q, query) do
    where(query, [p], ilike(p.content, ^"%#{q}%"))
  end
  
  defp check_boolean(boolean) do
    case boolean do
      {:ok, boolean} -> true
      _ -> false
    end
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """

  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
