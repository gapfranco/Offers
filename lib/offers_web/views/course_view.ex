defmodule OffersWeb.CourseView do
  use OffersWeb, :view
  alias OffersWeb.CourseView

  def render("index.json", %{courses: courses}) do
    %{data: render_many(courses, CourseView, "course.json")}
  end

  def render("show.json", %{course: course}) do
    %{data: render_one(course, CourseView, "course1.json")}
  end

  def render("course1.json", %{course: course}) do
    %{
      id: course.id,
      name: course.name,
      kind: course.kind,
      level: course.level,
      shift: course.shift,
      university_id: course.university_id,
      campus_id: course.campus_id
    }
  end

  def render("course.json", %{course: course}) do
    %{
      id: course.id,
      name: course.name,
      kind: course.kind,
      level: course.level,
      shift: course.shift,
      university: render_one(course.university, OffersWeb.UniversityView, "university.json"),
      campus: render_one(course.campus, OffersWeb.CampusView, "campus.json")
    }
  end
end
