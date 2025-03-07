defmodule OffersWeb.Router do
  use OffersWeb, :router
  alias Offers.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", OffersWeb do
    pipe_through :api
    post "/users/sign_in", UserController, :sign_in
    post "/users/sign_on", UserController, :sign_on
  end

  scope "/api", OffersWeb do
    pipe_through [:api, :jwt_authenticated]
    resources "/universities", UniversityController, except: [:new, :edit]
    resources "/campus", CampusController, except: [:new, :edit]
    resources "/courses", CourseController, except: [:new, :edit]
    resources "/bids", BidController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: OffersWeb.Telemetry
    end
  end
end
