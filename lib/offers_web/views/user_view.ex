defmodule OffersWeb.UserView do
  use OffersWeb, :view

  def render("sign_on.json", %{user: user}) do
    %{
      user: %{
        id: user.id,
        email: user.email
      }
    }
  end

  def render("sign_in.json", %{token: jwt_token}) do
    %{token: jwt_token}
  end
end
