Rails.application.routes.draw do
  root to: 'application#index'
  get '/', to: 'application#index' 
  get 'services', to: 'application#services' 
  get 'about-us', to: 'application#about_us' 
  get 'contact', to: 'application#contact' 
  get 'search-results', to: 'application#search' 
  get 'reservation', to: 'reservation#index' 
  post 'book', to: 'application#success' 
  post 'contact-message', to: 'application#message'
  resources :products
  match "*path" => redirect("/"), :via => [:get]
end
