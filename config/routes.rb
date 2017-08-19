Rails.application.routes.draw do
  resources :porters
  resources :valves
  mount Hyperloop::Engine => '/hyperloop'
  # For details on the DSL available within this file, see http://guides.rubyonrails.orgcd/routing.html
  root 'hyperloop#app'
end
