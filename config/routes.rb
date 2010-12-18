RubySwarm::Application.routes.draw do

  devise_for :users

  resources :useragents

  resources :jobs do
    collection do
      get 'run'
    end
  end

  resources :clients

  root :to => "welcome#index"

end
