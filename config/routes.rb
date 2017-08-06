Rails.application.routes.draw do
  resources :jobs do
    member do
      put :approve
      put :take_down
      put :publish
    end
  end

  resources :invitations
  resources :members, only: [:index, :show]

  scope path: ':user_id', as: 'user' do
    resource :profile
  end

  namespace :directory do
    resources :users, only: [:index, :show]
  end

  devise_for :users,
              controllers: {
                omniauth_callbacks: 'users/omniauth_callbacks'
              }

  mount Sidekiq::Web => '/sidekiq' # monitoring console

  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'
  get 'list-jobs-admin', to: 'jobs#list_jobs'

  # API resources
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :invitations, only: [:create]
    end
  end

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
