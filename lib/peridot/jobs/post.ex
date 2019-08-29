defmodule Peridot.Jobs.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :priority, :integer, default: 2
    field :relocate, :boolean, default: false
    field :remote, :boolean, default: false
    field :username, :string
    field :comment_id, :integer
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:username, :remote, :priority, :relocate, :content, :comment_id])
    |> validate_required([:username, :remote, :priority, :relocate, :content, :comment_id])
  end
end
