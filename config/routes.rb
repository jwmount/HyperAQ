Rails.application.routes.draw do
  resources :valve_actuators
  resources :crontab_actuators
  mount Hyperloop::Engine => '/hyperloop'

  resources :porters
  resources :scheduled_sprinkle_events
  resources :valves
  resources :water_managers

  root "hyperloop#app"
end
