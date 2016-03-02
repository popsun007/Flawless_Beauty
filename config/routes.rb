Rails.application.routes.draw do
  get '/', to: 'application#index' 
  get 'index.html', to: 'application#index' 
  get 'services.html', to: 'application#services' 
end
