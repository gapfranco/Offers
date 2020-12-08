defmodule OffersWeb.BidView do
  use OffersWeb, :view
  alias OffersWeb.BidView

  def render("index.json", %{bids: bids}) do
    %{data: render_many(bids, BidView, "bid.json")}
  end

  def render("show.json", %{bid: bid}) do
    %{data: render_one(bid, BidView, "bid.json")}
  end

  def render("bid.json", %{bid: bid}) do
    %{id: bid.id,
      full_price: bid.full_price,
      price_with_discount: bid.price_with_discount,
      discount_percentage: bid.discount_percentage,
      start_date: bid.start_date,
      enrollment_semester: bid.enrollment_semester,
      enabled: bid.enabled}
  end
end
