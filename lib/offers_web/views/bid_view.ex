defmodule OffersWeb.BidView do
  use OffersWeb, :view
  alias OffersWeb.BidView

  def render("index.json", %{bids: bids}) do
    %{data: render_many(bids, BidView, "bid.json")}
  end

  def render("show.json", %{bid: bid}) do
    %{data: render_one(bid, BidView, "bid1.json")}
  end

  def render("bid1.json", %{bid: bid}) do
    %{
      id: bid.id,
      full_price: bid.full_price,
      price_with_discount: bid.price_with_discount,
      discount_percentage: bid.discount_percentage,
      start_date: bid.start_date,
      enrollment_semester: bid.enrollment_semester,
      enabled: bid.enabled,
      course_id: bid.course_id,
      university_id: bid.university_id,
      campus_id: bid.campus_id
    }
  end

  def render("bid.json", %{bid: bid}) do
    %{
      id: bid.id,
      full_price: bid.full_price,
      price_with_discount: bid.price_with_discount,
      discount_percentage: bid.discount_percentage,
      start_date: bid.start_date,
      enrollment_semester: bid.enrollment_semester,
      enabled: bid.enabled,
      university: render_one(bid.university, OffersWeb.UniversityView, "university.json"),
      campus: render_one(bid.campus, OffersWeb.CampusView, "campus.json"),
      course: render_one(bid.course, OffersWeb.CourseView, "course1.json")
    }
  end
end
