defmodule Offers.Password do
  import Pbkdf2

  alias Offers.Guardian
  alias Offers.Account.User
  alias Offers.Repo

  def hash(password) do
    hash_pwd_salt(password)
  end

  def verify_with_hash(password, hash), do: verify_pass(password, hash)

  def dummy_verify, do: no_user_verify()

  def token_signin(email, password) do
    with {:ok, user} <- uid_password_auth(email, password),
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    end
  end

  defp uid_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
         do: verify_password(password, user)
  end

  defp get_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        dummy_verify()
        {:error, :login_error}

      user ->
        {:ok, user}
    end
  end

  def verify_password(password, %User{} = user) when is_binary(password) do
    if verify_with_hash(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :login_error}
    end
  end
end
