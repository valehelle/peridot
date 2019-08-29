defmodule Peridot.Repo.Migrations.CreateAsks do
  use Ecto.Migration

  def change do
    create table(:asks) do
      add :hacker_news_id, :string

      timestamps()
    end

  end
end
