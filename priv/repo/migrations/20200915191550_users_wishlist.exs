defmodule Akyuu.Repo.Migrations.UsersWishlist do
  use Ecto.Migration

  def change do
    create table(:users_wishlists, primary_key: false) do
      add :user_id, references(:users), primary_key: true, on_delete: :delete_all, on_update: :update_all
      add :album_id, references(:albums), primary_key: true, on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end
