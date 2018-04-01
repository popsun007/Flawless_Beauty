Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' }, :path_prefix => 'my'
  resources :users
  get '/', to: 'application#index'
  get 'services', to: 'application#services'
  get 'about-us', to: 'application#about_us'
  get 'calendars', to: 'calendars#index'
  get 'members', to: 'users#index'
  get 'redirect', to: 'calendars#redirect'
  get 'callback', to: 'calendars#callback'
  get 'contact', to: 'application#contact'
  get 'search-results', to: 'application#search'
  get 'reservation', to: 'reservation#index'
  post 'book', to: 'calendars#booking'
  post 'contact-message', to: 'application#message'
  delete 'appointment/:id', to: 'calendars#destroy'
  resources :products
  resources :packages
  root 'application#index'
  match "*path" => redirect("/"), :via => [:get]
end
