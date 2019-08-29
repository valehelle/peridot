defmodule Peridot.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :username, :string
      add :remote, :boolean, default: false, null: false
      add :priority, :integer
      add :relocate, :boolean, default: false, null: false
      add :content, :text
      add :comment_id, :integer

      timestamps()
    end

  end
end
