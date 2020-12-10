defmodule OffersWeb.BidController do
  use OffersWeb, :controller

  alias Offers.Teach
  alias Offers.Teach.Bid

  action_fallback OffersWeb.FallbackController

  def index(conn, params) do
    bids = Teach.list_bids(params)
    render(conn, "index.json", bids: bids)
  end

  def create(conn, %{"bid" => bid_params}) do
    with {:ok, %Bid{} = bid} <- Teach.create_bid(bid_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.bid_path(conn, :show, bid))
      |> render("show.json", bid: bid)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bid = Teach.get_bid!(id)
    render(conn, "show.json", bid: bid)
  end

  def update(conn, %{"id" => id, "bid" => bid_params}) do
    bid = Teach.get_bid!(id)

    with {:ok, %Bid{} = bid} <- Teach.update_bid(bid, bid_params) do
      render(conn, "show.json", bid: bid)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(OffersWeb.ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bid = Teach.get_bid!(id)

    with {:ok, %Bid{}} <- Teach.delete_bid(bid) do
      send_resp(conn, :no_content, "")
    end
  end
end
