defmodule RCTMS.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :rctms,
    error_handler: RCTMS.Accounts.ErrorHandler,
    module: RCTMS.Accounts.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
  # Ensure we have a valid user in the token
  plug Guardian.Plug.EnsureAuthenticated
end
