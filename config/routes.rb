RubySwarm::Application.routes.draw do

  devise_for :users

  resources :useragents

  resources :jobs do
    collection do
      get 'run'
    end
  end

  resources :clients, :only => [:index, :show]

  root :to => "welcome#index"

end
