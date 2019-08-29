defmodule Peridot.Hackernews.Ask do
  use Ecto.Schema
  import Ecto.Changeset

  schema "asks" do
    field :hacker_news_id, :string

    timestamps()
  end

  @doc false
  def changeset(ask, attrs) do
    ask
    |> cast(attrs, [:hacker_news_id])
    |> validate_required([:hacker_news_id])
  end
end
