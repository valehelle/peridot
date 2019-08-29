defmodule Peridot.Hackernews do
  @moduledoc """
  The Hackernews context.
  """

  import Ecto.Query, warn: false
  alias Peridot.Repo

  alias Peridot.Hackernews.Ask

  @doc """
  Returns the list of asks.

  ## Examples

      iex> list_asks()
      [%Ask{}, ...]

  """
  def list_asks do
    Repo.all(Ask)
  end

  @doc """
  Gets a single ask.

  Raises `Ecto.NoResultsError` if the Ask does not exist.

  ## Examples

      iex> get_ask!(123)
      %Ask{}

      iex> get_ask!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ask(id) do 
    query = from a in Ask,
      where: a.hacker_news_id == ^id
    Repo.get(Ask, id)
  end
  def get_latest_ask() do 
    Repo.one(from a in Ask, order_by: [desc: a.id], limit: 1)
  end
  @doc """
  Creates a ask.

  ## Examples

      iex> create_ask(%{field: value})
      {:ok, %Ask{}}

      iex> create_ask(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ask(attrs \\ %{}) do
    %Ask{}
    |> Ask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ask.

  ## Examples

      iex> update_ask(ask, %{field: new_value})
      {:ok, %Ask{}}

      iex> update_ask(ask, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ask(%Ask{} = ask, attrs) do
    ask
    |> Ask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Ask.

  ## Examples

      iex> delete_ask(ask)
      {:ok, %Ask{}}

      iex> delete_ask(ask)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ask(%Ask{} = ask) do
    Repo.delete(ask)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ask changes.

  ## Examples

      iex> change_ask(ask)
      %Ecto.Changeset{source: %Ask{}}

  """
  def change_ask(%Ask{} = ask) do
    Ask.changeset(ask, %{})
  end
end
