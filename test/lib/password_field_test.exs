defmodule AkyuuCrypto.PasswordFieldTest do
    use ExUnit.Case
    alias AkyuuCrypto.PasswordField

    test "verify_password checks the correct password" do
        password = "Hello World"
        hash = PasswordField.hash_password(password)
        result = PasswordField.verify_password(password, hash)

        assert result
    end


    test "verify_password fails with different passwords" do
        password = "Hello World"
        hash = PasswordField.hash_password(password)
        result = PasswordField.verify_password("oh hi", hash)

        assert !result
    end
end
