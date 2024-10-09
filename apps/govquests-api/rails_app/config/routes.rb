Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  mount RailsEventStore::Browser => "/res" if Rails.env.development?

  get 'siwe/nonce', to: 'siwe#nonce'
  post 'siwe/verify', to: 'siwe#verify'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
end
