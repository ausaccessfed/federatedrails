Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :federation_login
  manager.failure_app = FederatedRails::AuthController
end

Warden::Manager.serialize_into_session { |subject| subject.id }
Warden::Manager.serialize_from_session { |id| Subject.find_by_id(id) }

Warden::Strategies.add(:federation_login, FederatedRails::FederationStrategy)
Warden::Strategies.add(:development_login, FederatedRails::DevelopmentStrategy)