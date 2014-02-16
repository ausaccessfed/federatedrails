Rails.application.routes.draw do

  scope :module => 'federated_rails' do
    get '/login', :to => 'auth#login', :as => :login
    get '/logout', :to => 'auth#logout', :as => :logout
    get '/loginerror', :to => 'auth#unauthenticated'
    get '/auth/federation', :to => 'auth#federation_login'
    get '/auth/development', :to => 'auth#development_login'
  end

end
