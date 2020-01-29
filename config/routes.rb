Rails.application.routes.draw do
  resources :partners
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :jobs do
    member do
      put :pre_approve
      put :approve
      put :take_down
      put :publish
    end
  end

  resources :invitations do
    member do
      put :resend
      put :approve
    end
  end

  resources :members, only: [:index, :show]

  scope path: ':user_id', as: 'user' do
    resource :profile do
      get :reload_avatar
    end
  end

  namespace :directory do
    resources :users, only: [:index, :show]
  end

  devise_for :users,
              controllers: {
                omniauth_callbacks: 'users/omniauth_callbacks'
              }

  constraints AdminConstraint.new do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'
  get 'contact-us', to: 'home#contact'
  get 'list-jobs-admin', to: 'jobs#list_jobs'
  get 'list-invitations-admin', to: 'invitations#list_invitations'
  get 'events', to: 'home#events'

  # API resources
  namespace :api do
    namespace :v1 do
      resources :invitations, only: [:create]
      resources :jobs, :controller => :"jobs", only: [:index, :show]
    end
  end

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
