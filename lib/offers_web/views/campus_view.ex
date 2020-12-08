defmodule OffersWeb.CampusView do
  use OffersWeb, :view
  alias OffersWeb.CampusView

  def render("index.json", %{campus: campus}) do
    %{data: render_many(campus, CampusView, "campus.json")}
  end

  def render("show.json", %{campus: campus}) do
    %{data: render_one(campus, CampusView, "campus.json")}
  end

  def render("campus.json", %{campus: campus}) do
    %{id: campus.id,
      name: campus.name,
      city: campus.city}
  end
end
