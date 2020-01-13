Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'demo#index'

  resources :tests, only: [:index]
  match '/examples', to: ExamplesController, via: :get

end
