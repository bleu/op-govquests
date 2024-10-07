Rails.application.routes.draw do
  mount RailsEventStore::Browser => "/res" if Rails.env.development?

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  resources :quests, only: [:index, :show]
  resources :users, only: [] do
    member do
      get "points"
      get "available_rewards"
      post "claim_rewards"
      get "reward_inventory"
    end
  end

  resources :action_executions, only: [] do
    post "start", on: :collection
    post "complete", on: :collection
  end
end
