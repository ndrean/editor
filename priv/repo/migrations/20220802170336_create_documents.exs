defmodule Editor.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :name, :string
      add :data, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:documents, [:user_id])
  end
end
