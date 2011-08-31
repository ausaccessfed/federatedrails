
require 'federated_rails/acts_as_federated'
require 'federated_rails/authentication_controller_extension'
require 'federated_rails/security_manager'

module FederatedRails
  class Railtie < Rails::Railtie
    initializer 'federated_rails.action_controller_federated_extension' do |app|
      ActionController::Base.send :extend, ::FederatedRails::ActionControllerExtension::ClassMethods
    end
  end
end