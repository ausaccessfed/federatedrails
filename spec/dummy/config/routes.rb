Dummy::Application.routes.draw do

  root 'example#index'
  get '/example', :to => 'example#index'

end
