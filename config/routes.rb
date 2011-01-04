RubySwarm::Application.routes.draw do

  devise_for :users

  resources :useragents

  resources :jobs, :except => [:edit, :update] do
    collection do
      get 'run'
    end
  end

  resources :clients, :only => [:index, :show]

  resources :runs, :only => [:update] do
    collection do
      get 'get'
    end
  end

  root :to => "welcome#index"

end
