defmodule OffersWeb.BidControllerTest do
  use OffersWeb.ConnCase

  alias Offers.Teach
  alias Offers.Teach.Bid

  @create_attrs %{
    discount_percentage: 120.5,
    enabled: true,
    enrollment_semester: "some enrollment_semester",
    full_price: 120.5,
    price_with_discount: 120.5,
    start_date: "some start_date"
  }
  @update_attrs %{
    discount_percentage: 456.7,
    enabled: false,
    enrollment_semester: "some updated enrollment_semester",
    full_price: 456.7,
    price_with_discount: 456.7,
    start_date: "some updated start_date"
  }
  @invalid_attrs %{discount_percentage: nil, enabled: nil, enrollment_semester: nil, full_price: nil, price_with_discount: nil, start_date: nil}

  def fixture(:bid) do
    {:ok, bid} = Teach.create_bid(@create_attrs)
    bid
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bids", %{conn: conn} do
      conn = get(conn, Routes.bid_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bid" do
    test "renders bid when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bid_path(conn, :create), bid: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bid_path(conn, :show, id))

      assert %{
               "id" => id,
               "discount_percentage" => 120.5,
               "enabled" => true,
               "enrollment_semester" => "some enrollment_semester",
               "full_price" => 120.5,
               "price_with_discount" => 120.5,
               "start_date" => "some start_date"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bid_path(conn, :create), bid: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bid" do
    setup [:create_bid]

    test "renders bid when data is valid", %{conn: conn, bid: %Bid{id: id} = bid} do
      conn = put(conn, Routes.bid_path(conn, :update, bid), bid: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bid_path(conn, :show, id))

      assert %{
               "id" => id,
               "discount_percentage" => 456.7,
               "enabled" => false,
               "enrollment_semester" => "some updated enrollment_semester",
               "full_price" => 456.7,
               "price_with_discount" => 456.7,
               "start_date" => "some updated start_date"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bid: bid} do
      conn = put(conn, Routes.bid_path(conn, :update, bid), bid: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bid" do
    setup [:create_bid]

    test "deletes chosen bid", %{conn: conn, bid: bid} do
      conn = delete(conn, Routes.bid_path(conn, :delete, bid))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bid_path(conn, :show, bid))
      end
    end
  end

  defp create_bid(_) do
    bid = fixture(:bid)
    %{bid: bid}
  end
end
