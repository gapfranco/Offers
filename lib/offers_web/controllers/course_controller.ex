defmodule OffersWeb.CourseController do
  use OffersWeb, :controller

  alias Offers.Teach
  alias Offers.Teach.Course

  action_fallback OffersWeb.FallbackController

  def index(conn, params) do
    courses = Teach.list_courses(params)
    render(conn, "index.json", courses: courses)
  end

  def create(conn, %{"course" => course_params}) do
    with {:ok, %Course{} = course} <- Teach.create_course(course_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.course_path(conn, :show, course))
      |> render("show.json", course: course)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Teach.get_course!(id)
    render(conn, "show.json", course: course)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Teach.get_course!(id)

    with {:ok, %Course{} = course} <- Teach.update_course(course, course_params) do
      render(conn, "show.json", course: course)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Teach.get_course!(id)

    with {:ok, %Course{}} <- Teach.delete_course(course) do
      send_resp(conn, :no_content, "")
    end
  end
end
