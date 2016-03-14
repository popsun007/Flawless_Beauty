Rails.application.routes.draw do
  devise_for :users
  get '/', to: 'application#index' 
  get 'services', to: 'application#services' 
  get 'about-us', to: 'application#about_us' 
  get 'contact', to: 'application#contact' 
  get 'search-results', to: 'application#search' 
  get 'reservation', to: 'reservation#index' 
  post 'book', to: 'application#success' 
  post 'contact-message', to: 'application#message'
  resources :products
  root 'application#index'
  match "*path" => redirect("/"), :via => [:get]
end
