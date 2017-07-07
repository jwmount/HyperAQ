Rails.application.routes.draw do
  mount Hyperloop::Engine => '/hyperloop'

  resources :porters
  resources :scheduled_sprinkle_events
  resources :valves
  resources :water_managers

  root "hyperloop#app"
end
