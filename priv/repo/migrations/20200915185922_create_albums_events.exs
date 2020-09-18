defmodule Akyuu.Repo.Migrations.CreateAlbumsEvents do
  use Ecto.Migration

  def change do
    create table(:albums_events, primary_key: false) do
      add :price_jpy, :integer, null: false, default: 1000

      add :album_id, references(:albums), primary_key: true
      add :event_id, references(:events), primary_key: true

      timestamps()
    end
  end
end
