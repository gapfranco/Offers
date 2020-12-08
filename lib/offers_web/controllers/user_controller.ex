defmodule OffersWeb.UserController do
  use OffersWeb, :controller

  alias Offers.Account
  alias Offers.Account.User
  alias Offers.Password

  action_fallback OffersWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password} = _params) do
    case Password.token_signin(email, password) do
      {:ok, %{token: jwt_token, user: user}} ->
        conn
        |> render("sign_in.json", token: jwt_token)

      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def sign_on(conn, params) do
    case Account.create_user(params) do
      {:ok, user} ->
        conn
        |> render("sign_on.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end
end
