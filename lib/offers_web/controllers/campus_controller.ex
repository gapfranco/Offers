defmodule OffersWeb.CampusController do
  use OffersWeb, :controller

  alias Offers.Teach
  alias Offers.Teach.Campus

  action_fallback OffersWeb.FallbackController

  def index(conn, _params) do
    campus = Teach.list_campus()
    render(conn, "index.json", campus: campus)
  end

  def create(conn, %{"campus" => campus_params}) do
    with {:ok, %Campus{} = campus} <- Teach.create_campus(campus_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.campus_path(conn, :show, campus))
      |> render("show.json", campus: campus)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    campus = Teach.get_campus!(id)
    render(conn, "show.json", campus: campus)
  end

  def update(conn, %{"id" => id, "campus" => campus_params}) do
    campus = Teach.get_campus!(id)

    with {:ok, %Campus{} = campus} <- Teach.update_campus(campus, campus_params) do
      render(conn, "show.json", campus: campus)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    campus = Teach.get_campus!(id)

    with {:ok, %Campus{}} <- Teach.delete_campus(campus) do
      send_resp(conn, :no_content, "")
    end
  end
end
