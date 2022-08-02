defmodule Editor.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "documents" do
    field :data, :string
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:name, :data])
    |> validate_required([:name, :data])
  end
end
