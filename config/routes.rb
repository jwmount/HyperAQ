Rails.application.routes.draw do
  get 'home/topPane'

  mount Hyperloop::Engine => '/hyperloop'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#topPane'
end
