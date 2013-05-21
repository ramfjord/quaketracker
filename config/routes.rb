Quaketracker::Application.routes.draw do
  get 'earthquakes', to: 'quakes#index', as: 'quakes' 
  match 'near_me', to: 'quakes#nearme', as: 'nearme', via: [:get, :post]

  root to: 'quakes#nearme'
end
