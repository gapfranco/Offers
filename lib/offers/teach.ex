defmodule Offers.Teach do
  @moduledoc """
  The Teach context.
  """

  import Ecto.Query, warn: false
  alias Offers.Repo

  alias Offers.Teach.University

  @doc """
  Returns the list of universities.

  ## Examples

      iex> list_universities()
      [%University{}, ...]

  """
  def list_universities do
    Repo.all(University)
  end

  @doc """
  Gets a single university.

  Raises `Ecto.NoResultsError` if the University does not exist.

  ## Examples

      iex> get_university!(123)
      %University{}

      iex> get_university!(456)
      ** (Ecto.NoResultsError)

  """
  def get_university!(id), do: Repo.get!(University, id)

  def get_university_by_name(name) when is_binary(name) do
    Repo.get_by(University, name: name)
  end

  @doc """
  Creates a university.

  ## Examples

      iex> create_university(%{field: value})
      {:ok, %University{}}

      iex> create_university(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_university(attrs \\ %{}) do
    %University{}
    |> University.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a university.

  ## Examples

      iex> update_university(university, %{field: new_value})
      {:ok, %University{}}

      iex> update_university(university, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_university(%University{} = university, attrs) do
    university
    |> University.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a university.

  ## Examples

      iex> delete_university(university)
      {:ok, %University{}}

      iex> delete_university(university)
      {:error, %Ecto.Changeset{}}

  """
  def delete_university(%University{} = university) do
    Repo.delete(university)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking university changes.

  ## Examples

      iex> change_university(university)
      %Ecto.Changeset{data: %University{}}

  """
  def change_university(%University{} = university, attrs \\ %{}) do
    University.changeset(university, attrs)
  end

  alias Offers.Teach.Campus

  @doc """
  Returns the list of campus.

  ## Examples

      iex> list_campus()
      [%Campus{}, ...]

  """
  def list_campus do
    Repo.all(Campus)
  end

  @doc """
  Gets a single campus.

  Raises `Ecto.NoResultsError` if the Campus does not exist.

  ## Examples

      iex> get_campus!(123)
      %Campus{}

      iex> get_campus!(456)
      ** (Ecto.NoResultsError)

  """
  def get_campus!(id), do: Repo.get!(Campus, id)

  def get_campus_by_name(name) when is_binary(name) do
    Repo.get_by(Campus, name: name)
  end

  @doc """
  Creates a campus.

  ## Examples

      iex> create_campus(%{field: value})
      {:ok, %Campus{}}

      iex> create_campus(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_campus(attrs \\ %{}) do
    %Campus{}
    |> Campus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a campus.

  ## Examples

      iex> update_campus(campus, %{field: new_value})
      {:ok, %Campus{}}

      iex> update_campus(campus, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_campus(%Campus{} = campus, attrs) do
    campus
    |> Campus.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a campus.

  ## Examples

      iex> delete_campus(campus)
      {:ok, %Campus{}}

      iex> delete_campus(campus)
      {:error, %Ecto.Changeset{}}

  """
  def delete_campus(%Campus{} = campus) do
    Repo.delete(campus)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking campus changes.

  ## Examples

      iex> change_campus(campus)
      %Ecto.Changeset{data: %Campus{}}

  """
  def change_campus(%Campus{} = campus, attrs \\ %{}) do
    Campus.changeset(campus, attrs)
  end

  alias Offers.Teach.Course

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses(params) do
    Course
    |> join(:inner, [p], assoc(p, :university), as: :university)
    |> join(:inner, [p], assoc(p, :campus), as: :campus)
    |> where(^courses_where(params))
    |> Repo.all()
    |> Repo.preload([:university, :campus])
  end

  def courses_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {"university", value}, dynamic ->
        dynamic([university: u], ^dynamic and u.name == ^value)

      {"course", value}, dynamic ->
        dynamic([p], ^dynamic and p.name == ^value)

      {"kind", value}, dynamic ->
        dynamic([p], ^dynamic and p.kind == ^value)

      {"level", value}, dynamic ->
        dynamic([p], ^dynamic and p.level == ^value)

      {"shift", value}, dynamic ->
        dynamic([p], ^dynamic and p.level == ^value)

      {"campus", value}, dynamic ->
        dynamic([campus: a], ^dynamic and a.name == ^value)

      {"city", value}, dynamic ->
        dynamic([campus: a], ^dynamic and a.city == ^value)

      {_, _}, dynamic ->
        # Not a where parameter
        dynamic
    end)
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.

  ## Examples

      iex> get_course!(123)
      %Course{}

      iex> get_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course!(id), do: Repo.get!(Course, id)

  def get_course_by_name(name) when is_binary(name) do
    Repo.get_by(Course, name: name)
  end

  @doc """
  Creates a course.

  ## Examples

      iex> create_course(%{field: value})
      {:ok, %Course{}}

      iex> create_course(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course.

  ## Examples

      iex> update_course(course, %{field: new_value})
      {:ok, %Course{}}

      iex> update_course(course, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course(%Course{} = course, attrs) do
    course
    |> Course.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a course.

  ## Examples

      iex> delete_course(course)
      {:ok, %Course{}}

      iex> delete_course(course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course changes.

  ## Examples

      iex> change_course(course)
      %Ecto.Changeset{data: %Course{}}

  """
  def change_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end

  alias Offers.Teach.Bid

  @doc """
  Returns the list of bids.

  ## Examples

      iex> list_bids()
      [%Bid{}, ...]

  """
  def list_bids(params) do
    Bid
    |> join(:inner, [p], assoc(p, :university), as: :university)
    |> join(:inner, [p], assoc(p, :course), as: :course)
    |> join(:inner, [p], assoc(p, :campus), as: :campus)
    |> order_by(^bids_order_by(params["order_by"]))
    |> where(^bids_where(params))
    |> Repo.all()
    |> Repo.preload([:university, :campus, :course])
  end

  def bids_order_by("asc_price"), do: [asc: dynamic([p], p.price_with_discount)]
  def bids_order_by("desc_price"), do: [desc: dynamic([p], p.price_with_discount)]
  def bids_order_by(_), do: []

  def bids_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {"university", value}, dynamic ->
        dynamic([university: u], ^dynamic and u.name == ^value)

      {"course", value}, dynamic ->
        dynamic([course: c], ^dynamic and c.name == ^value)

      {"kind", value}, dynamic ->
        dynamic([course: c], ^dynamic and c.kind == ^value)

      {"level", value}, dynamic ->
        dynamic([course: c], ^dynamic and c.level == ^value)

      {"shift", value}, dynamic ->
        dynamic([course: c], ^dynamic and c.level == ^value)

      {"campus", value}, dynamic ->
        dynamic([campus: a], ^dynamic and a.name == ^value)

      {"city", value}, dynamic ->
        dynamic([campus: a], ^dynamic and a.city == ^value)

      {_, _}, dynamic ->
        # Not a where parameter
        dynamic
    end)
  end

  @doc """
  Gets a single bid.

  Raises `Ecto.NoResultsError` if the Bid does not exist.

  ## Examples

      iex> get_bid!(123)
      %Bid{}

      iex> get_bid!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bid!(id), do: Repo.get!(Bid, id)

  @doc """
  Creates a bid.

  ## Examples

      iex> create_bid(%{field: value})
      {:ok, %Bid{}}

      iex> create_bid(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bid(attrs \\ %{}) do
    %Bid{}
    |> Bid.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bid.

  ## Examples

      iex> update_bid(bid, %{field: new_value})
      {:ok, %Bid{}}

      iex> update_bid(bid, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bid(%Bid{} = bid, attrs) do
    bid
    |> Bid.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bid.

  ## Examples

      iex> delete_bid(bid)
      {:ok, %Bid{}}

      iex> delete_bid(bid)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bid(%Bid{} = bid) do
    Repo.delete(bid)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bid changes.

  ## Examples

      iex> change_bid(bid)
      %Ecto.Changeset{data: %Bid{}}

  """
  def change_bid(%Bid{} = bid, attrs \\ %{}) do
    Bid.changeset(bid, attrs)
  end
end
