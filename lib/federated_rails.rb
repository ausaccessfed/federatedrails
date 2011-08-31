require 'rails'
require 'rails_warden'

module FederatedRails
	require 'federated_rails/engine' if defined?(Rails)
	require 'federated_rails/railtie'  if defined?(Rails)

	require 'federated_rails/federation_strategy'
	require 'federated_rails/development_strategy'
end