defmodule Offers.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :Offer,
    module: Offers.Guardian,
    error_handler: Offers.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
