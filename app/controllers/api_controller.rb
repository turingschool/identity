class ApiController < ApplicationController
  # FIXME: we need some other form of auth here
  skip_before_filter :require_login
end
