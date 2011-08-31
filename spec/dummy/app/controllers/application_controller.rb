class ApplicationController < ActionController::Base
  protect_from_forgery
  acts_as_federated
end
