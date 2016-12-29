Rails.application.routes.draw do
  devise_for :admins
  resources :invitations
  resources :profiles
  devise_for :users,
             controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  mount Sidekiq::Web => '/sidekiq' # monitoring console

  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
