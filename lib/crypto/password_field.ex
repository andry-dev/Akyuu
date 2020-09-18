defmodule AkyuuCrypto.PasswordField do
    @behaviour Ecto.Type

    def type, do: :binary

    def cast(value) do
        {:ok, to_string(value)}
    end

    def dump(value) do
        {:ok, hash_password(value)}
    end

    def load(value) do
        {:ok, value}
    end

    def embed_as(_), do: :self

    def equal?(x, y), do: x == y

    def hash_password(pass) do
        Argon2.Base.hash_password(to_string(pass),
            Argon2.gen_salt(), [{:argon2_type, 2}])
    end

    def verify_password(pass, hash) do
        Argon2.verify_pass(pass, hash)
    end
end
