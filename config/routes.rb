RubySwarm::Application.routes.draw do

  devise_for :users

  resources :useragents

  resources :jobs, :except => [:edit, :update] do
    collection do
      get 'run'
      get 'get_run'
    end
  end

  resources :clients, :only => [:index, :show]

  root :to => "welcome#index"

end
