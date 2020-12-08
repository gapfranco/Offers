defmodule Offers.TeachTest do
  use Offers.DataCase

  alias Offers.Teach

  describe "universities" do
    alias Offers.Teach.University

    @valid_attrs %{logo_url: "some logo_url", name: "some name", score: 120.5}
    @update_attrs %{logo_url: "some updated logo_url", name: "some updated name", score: 456.7}
    @invalid_attrs %{logo_url: nil, name: nil, score: nil}

    def university_fixture(attrs \\ %{}) do
      {:ok, university} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Teach.create_university()

      university
    end

    test "list_universities/0 returns all universities" do
      university = university_fixture()
      assert Teach.list_universities() == [university]
    end

    test "get_university!/1 returns the university with given id" do
      university = university_fixture()
      assert Teach.get_university!(university.id) == university
    end

    test "create_university/1 with valid data creates a university" do
      assert {:ok, %University{} = university} = Teach.create_university(@valid_attrs)
      assert university.logo_url == "some logo_url"
      assert university.name == "some name"
      assert university.score == 120.5
    end

    test "create_university/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teach.create_university(@invalid_attrs)
    end

    test "update_university/2 with valid data updates the university" do
      university = university_fixture()
      assert {:ok, %University{} = university} = Teach.update_university(university, @update_attrs)
      assert university.logo_url == "some updated logo_url"
      assert university.name == "some updated name"
      assert university.score == 456.7
    end

    test "update_university/2 with invalid data returns error changeset" do
      university = university_fixture()
      assert {:error, %Ecto.Changeset{}} = Teach.update_university(university, @invalid_attrs)
      assert university == Teach.get_university!(university.id)
    end

    test "delete_university/1 deletes the university" do
      university = university_fixture()
      assert {:ok, %University{}} = Teach.delete_university(university)
      assert_raise Ecto.NoResultsError, fn -> Teach.get_university!(university.id) end
    end

    test "change_university/1 returns a university changeset" do
      university = university_fixture()
      assert %Ecto.Changeset{} = Teach.change_university(university)
    end
  end

  describe "campus" do
    alias Offers.Teach.Campus

    @valid_attrs %{city: "some city", name: "some name"}
    @update_attrs %{city: "some updated city", name: "some updated name"}
    @invalid_attrs %{city: nil, name: nil}

    def campus_fixture(attrs \\ %{}) do
      {:ok, campus} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Teach.create_campus()

      campus
    end

    test "list_campus/0 returns all campus" do
      campus = campus_fixture()
      assert Teach.list_campus() == [campus]
    end

    test "get_campus!/1 returns the campus with given id" do
      campus = campus_fixture()
      assert Teach.get_campus!(campus.id) == campus
    end

    test "create_campus/1 with valid data creates a campus" do
      assert {:ok, %Campus{} = campus} = Teach.create_campus(@valid_attrs)
      assert campus.city == "some city"
      assert campus.name == "some name"
    end

    test "create_campus/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teach.create_campus(@invalid_attrs)
    end

    test "update_campus/2 with valid data updates the campus" do
      campus = campus_fixture()
      assert {:ok, %Campus{} = campus} = Teach.update_campus(campus, @update_attrs)
      assert campus.city == "some updated city"
      assert campus.name == "some updated name"
    end

    test "update_campus/2 with invalid data returns error changeset" do
      campus = campus_fixture()
      assert {:error, %Ecto.Changeset{}} = Teach.update_campus(campus, @invalid_attrs)
      assert campus == Teach.get_campus!(campus.id)
    end

    test "delete_campus/1 deletes the campus" do
      campus = campus_fixture()
      assert {:ok, %Campus{}} = Teach.delete_campus(campus)
      assert_raise Ecto.NoResultsError, fn -> Teach.get_campus!(campus.id) end
    end

    test "change_campus/1 returns a campus changeset" do
      campus = campus_fixture()
      assert %Ecto.Changeset{} = Teach.change_campus(campus)
    end
  end

  describe "courses" do
    alias Offers.Teach.Course

    @valid_attrs %{kind: "some kind", level: "some level", name: "some name", shift: "some shift"}
    @update_attrs %{kind: "some updated kind", level: "some updated level", name: "some updated name", shift: "some updated shift"}
    @invalid_attrs %{kind: nil, level: nil, name: nil, shift: nil}

    def course_fixture(attrs \\ %{}) do
      {:ok, course} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Teach.create_course()

      course
    end

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Teach.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Teach.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      assert {:ok, %Course{} = course} = Teach.create_course(@valid_attrs)
      assert course.kind == "some kind"
      assert course.level == "some level"
      assert course.name == "some name"
      assert course.shift == "some shift"
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teach.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()
      assert {:ok, %Course{} = course} = Teach.update_course(course, @update_attrs)
      assert course.kind == "some updated kind"
      assert course.level == "some updated level"
      assert course.name == "some updated name"
      assert course.shift == "some updated shift"
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = course_fixture()
      assert {:error, %Ecto.Changeset{}} = Teach.update_course(course, @invalid_attrs)
      assert course == Teach.get_course!(course.id)
    end

    test "delete_course/1 deletes the course" do
      course = course_fixture()
      assert {:ok, %Course{}} = Teach.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Teach.get_course!(course.id) end
    end

    test "change_course/1 returns a course changeset" do
      course = course_fixture()
      assert %Ecto.Changeset{} = Teach.change_course(course)
    end
  end
end
