defmodule OffersWeb.UniversityController do
  use OffersWeb, :controller

  alias Offers.Teach
  alias Offers.Teach.University

  action_fallback OffersWeb.FallbackController

  def index(conn, _params) do
    universities = Teach.list_universities()
    render(conn, "index.json", universities: universities)
  end

  def create(conn, %{"university" => university_params}) do
    with {:ok, %University{} = university} <- Teach.create_university(university_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.university_path(conn, :show, university))
      |> render("show.json", university: university)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    university = Teach.get_university!(id)
    render(conn, "show.json", university: university)
  end

  def update(conn, %{"id" => id, "university" => university_params}) do
    university = Teach.get_university!(id)

    with {:ok, %University{} = university} <-
           Teach.update_university(university, university_params) do
      render(conn, "show.json", university: university)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    university = Teach.get_university!(id)

    with {:ok, %University{}} <- Teach.delete_university(university) do
      send_resp(conn, :no_content, "")
    end
  end
end
