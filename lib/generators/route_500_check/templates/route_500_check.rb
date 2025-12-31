# Route500Check configuration file
#
# This file defines which routes should be checked for HTTP 500 errors.
# Routes are expanded and validated before execution to ensure safe operation.
#
# No HTTP requests are sent if validation fails.

# Base URL for requests.
# In production, it is recommended to use the environment variable
# ROUTE500CHECK_BASE_URL instead of hard-coding this value.
#
# Example:
#   ROUTE500CHECK_BASE_URL=https://example.com bundle exec route500check
#
base_url "http://localhost:3000"

# Global safety limit.
# This is an absolute upper bound for the total number of HTTP requests
# after route expansion.
#
default_limit 50

# Run checks only for public-facing pages.
# Useful when executing against production environments.
#
# only_public do
#   exclude_prefix "/admin"
#   exclude_prefix "/api"
# end

# -----------------------
# Route definitions
# -----------------------

# Simple static route
route "/"

# Route with path parameters
route "/items/:id" do
  id 1..100
  sample 10
end

# Route with explicit limit
route "/categories/:category_id" do
  category_id [1, 2, 3, 4, 5]
  limit 5
end

# -----------------------
# Optional settings
# -----------------------

# Ignore specific HTTP status codes when determining exit code.
# These statuses are still logged and written to JSON output.
#
# ignore_status [502, 503]
