defmodule Akyuu.Repo.Migrations.UsersWishlist do
  use Ecto.Migration

  def change do
    create table(:users_wishlist, primary_key: false) do
      add :user_id, references(:users), primary_key: true
      add :album_id, references(:albums), primary_key: true

      timestamps()
    end
  end
end
