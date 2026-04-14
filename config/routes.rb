Rails.application.routes.draw do
  root 'sessions#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  
  get '/principal', to: 'home#index', as: 'principal'
  get '/menu_dinamico', to: 'menus#dinamico'
  get '/api/perfil', to: 'usuarios#perfil_actual'
  
  # Pantallas Estáticas con guiones medios
  get '/principal-1-1', to: 'principals#p1_1'
  get '/principal-1-2', to: 'principals#p1_2'
  get '/principal-2-1', to: 'principals#p2_1'
  get '/principal-2-2', to: 'principals#p2_2'
  
  resources :perfils
  resources :modulos
  resources :permisos_perfils
  resources :usuarios

  # Rutas de Errores
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end