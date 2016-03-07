Rails.application.routes.draw do
  get 'reservation/index'

  get '/', to: 'application#index' 
  get 'index.html', to: 'application#index' 
  get 'services.html', to: 'application#services' 
  get 'about-us.html', to: 'application#about_us' 
  get 'contact.html', to: 'application#contact' 
  get 'search-results', to: 'application#search' 
  get 'ajax/reservation-form.html', to: 'reservation#index' 
  post 'book', to: 'reservation#send_email' 
end
