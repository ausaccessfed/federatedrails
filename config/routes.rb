Rails.application.routes.draw do

  scope :module => 'federated_rails' do
    match '/login', :to => 'auth#login', :as => :login
    match '/logout', :to => 'auth#logout', :as => :logout
    match '/loginerror', :to => 'auth#unauthenticated'
    match '/auth/federation', :to => 'auth#federation_login'
    match '/auth/development', :to => 'auth#development_login'
  end

end