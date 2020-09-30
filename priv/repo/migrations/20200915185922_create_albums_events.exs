defmodule Akyuu.Repo.Migrations.CreateAlbumsEvents do
  use Ecto.Migration

  def change do
    create table(:albums_events, primary_key: false) do
      add :price_jpy, :integer, null: false, default: 1000

      add :album_id, references(:albums), primary_key: true, on_delete: :delete_all, on_update: :update_all
      add :event_id, references(:event_editions), primary_key: true, on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end
