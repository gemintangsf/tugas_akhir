Rails.application.routes.draw do
  resources :admins
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, param: :username
  post '/login', to: 'authentication#login'
  
  resource :admins do
    post "/create" => "admins#createAdmin"
  end
end
