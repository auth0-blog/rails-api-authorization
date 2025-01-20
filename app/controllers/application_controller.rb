class ApplicationController < ActionController::API
  include Secured
  include Authorized

  ADMIN='admin'
end
