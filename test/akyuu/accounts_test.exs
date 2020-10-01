defmodule Akyuu.AccountsTest do
  use Akyuu.DataCase

  alias Akyuu.Accounts

  describe "users" do
    @valid_attrs %{
      username: "someusername",
      email: "user@example.com",
      password: "any password",
      password_confirmation: "any password",
      public?: false,
      indexed?: false
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      %{user | password: nil}
    end

    test "list_users/1 returns all users" do
      # Password is a virtual field, we can't have that
      user = user_fixture()

      assert Accounts.list_users() == [user]
    end

    test "search_user/1 can find indexed users" do
      user = user_fixture(%{public?: true, indexed?: true})

      assert Accounts.search_user("someusername") == [user]
    end

    test "search_user/1 can't find unindexed users" do
      _user = user_fixture()

      assert Accounts.search_user("someusername") == []
    end
  end

end
