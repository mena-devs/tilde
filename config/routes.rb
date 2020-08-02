# == Route Map
#
#                         Prefix Verb     URI Pattern                                                                              Controller#Action
#                      rswag_api          /api-docs                                                                                Rswag::Api::Engine
#                       rswag_ui          /api/v1/api-docs                                                                         Rswag::Ui::Engine
#              letter_opener_web          /letter_opener                                                                           LetterOpenerWeb::Engine
#                       partners GET      /partners(.:format)                                                                      partners#index
#                                POST     /partners(.:format)                                                                      partners#create
#                    new_partner GET      /partners/new(.:format)                                                                  partners#new
#                   edit_partner GET      /partners/:id/edit(.:format)                                                             partners#edit
#                        partner GET      /partners/:id(.:format)                                                                  partners#show
#                                PATCH    /partners/:id(.:format)                                                                  partners#update
#                                PUT      /partners/:id(.:format)                                                                  partners#update
#                                DELETE   /partners/:id(.:format)                                                                  partners#destroy
#                pre_approve_job PUT      /jobs/:id/pre_approve(.:format)                                                          jobs#pre_approve
#                    approve_job PUT      /jobs/:id/approve(.:format)                                                              jobs#approve
#                  take_down_job PUT      /jobs/:id/take_down(.:format)                                                            jobs#take_down
#                   feedback_job GET      /jobs/:id/feedback(.:format)                                                             jobs#feedback
#                           jobs GET      /jobs(.:format)                                                                          jobs#index
#                                POST     /jobs(.:format)                                                                          jobs#create
#                        new_job GET      /jobs/new(.:format)                                                                      jobs#new
#                       edit_job GET      /jobs/:id/edit(.:format)                                                                 jobs#edit
#                            job GET      /jobs/:id(.:format)                                                                      jobs#show
#                                PATCH    /jobs/:id(.:format)                                                                      jobs#update
#                                PUT      /jobs/:id(.:format)                                                                      jobs#update
#                                DELETE   /jobs/:id(.:format)                                                                      jobs#destroy
#              resend_invitation PUT      /invitations/:id/resend(.:format)                                                        invitations#resend
#             approve_invitation PUT      /invitations/:id/approve(.:format)                                                       invitations#approve
#                    invitations GET      /invitations(.:format)                                                                   invitations#index
#                                POST     /invitations(.:format)                                                                   invitations#create
#                 new_invitation GET      /invitations/new(.:format)                                                               invitations#new
#                edit_invitation GET      /invitations/:id/edit(.:format)                                                          invitations#edit
#                     invitation GET      /invitations/:id(.:format)                                                               invitations#show
#                                PATCH    /invitations/:id(.:format)                                                               invitations#update
#                                PUT      /invitations/:id(.:format)                                                               invitations#update
#                                DELETE   /invitations/:id(.:format)                                                               invitations#destroy
# news_email_subscribers_members GET      /members/news_email_subscribers(.:format)                                                members#news_email_subscribers
# jobs_email_subscribers_members GET      /members/jobs_email_subscribers(.:format)                                                members#jobs_email_subscribers
#                        members GET      /members(.:format)                                                                       members#index
#                                POST     /members(.:format)                                                                       members#create
#                     new_member GET      /members/new(.:format)                                                                   members#new
#                    edit_member GET      /members/:id/edit(.:format)                                                              members#edit
#                         member PATCH    /members/:id(.:format)                                                                   members#update
#                                PUT      /members/:id(.:format)                                                                   members#update
#                                DELETE   /members/:id(.:format)                                                                   members#destroy
#     reload_avatar_user_profile GET      /:user_id/profile/reload_avatar(.:format)                                                profiles#reload_avatar
#               new_user_profile GET      /:user_id/profile/new(.:format)                                                          profiles#new
#              edit_user_profile GET      /:user_id/profile/edit(.:format)                                                         profiles#edit
#                   user_profile GET      /:user_id/profile(.:format)                                                              profiles#show
#                                PATCH    /:user_id/profile(.:format)                                                              profiles#update
#                                PUT      /:user_id/profile(.:format)                                                              profiles#update
#                                DELETE   /:user_id/profile(.:format)                                                              profiles#destroy
#                                POST     /:user_id/profile(.:format)                                                              profiles#create
#               new_user_session GET      /users/sign_in(.:format)                                                                 devise/sessions#new
#                   user_session POST     /users/sign_in(.:format)                                                                 devise/sessions#create
#           destroy_user_session GET      /users/sign_out(.:format)                                                                devise/sessions#destroy
#  user_slack_omniauth_authorize GET|POST /users/auth/slack(.:format)                                                              users/omniauth_callbacks#passthru
#   user_slack_omniauth_callback GET|POST /users/auth/slack/callback(.:format)                                                     users/omniauth_callbacks#slack
#              new_user_password GET      /users/password/new(.:format)                                                            devise/passwords#new
#             edit_user_password GET      /users/password/edit(.:format)                                                           devise/passwords#edit
#                  user_password PATCH    /users/password(.:format)                                                                devise/passwords#update
#                                PUT      /users/password(.:format)                                                                devise/passwords#update
#                                POST     /users/password(.:format)                                                                devise/passwords#create
#       cancel_user_registration GET      /users/cancel(.:format)                                                                  devise/registrations#cancel
#          new_user_registration GET      /users/sign_up(.:format)                                                                 devise/registrations#new
#         edit_user_registration GET      /users/edit(.:format)                                                                    devise/registrations#edit
#              user_registration PATCH    /users(.:format)                                                                         devise/registrations#update
#                                PUT      /users(.:format)                                                                         devise/registrations#update
#                                DELETE   /users(.:format)                                                                         devise/registrations#destroy
#                                POST     /users(.:format)                                                                         devise/registrations#create
#          new_user_confirmation GET      /users/confirmation/new(.:format)                                                        devise/confirmations#new
#              user_confirmation GET      /users/confirmation(.:format)                                                            devise/confirmations#show
#                                POST     /users/confirmation(.:format)                                                            devise/confirmations#create
#                directory_users GET      /directory/users(.:format)                                                               directory/users#index
#                 directory_user GET      /directory/users/:id(.:format)                                                           directory/users#show
#                    sidekiq_web          /admin/sidekiq                                                                           Sidekiq::Web
#              private_dashboard GET      /private/dashboard(.:format)                                                             private/dashboards#show
#   update_state_private_api_key PUT      /private/api_keys/:id/update_state(.:format)                                             private/api_keys#update_state
#  update_access_private_api_key PUT      /private/api_keys/:id/update_access(.:format)                                            private/api_keys#update_access
#               private_api_keys GET      /private/api_keys(.:format)                                                              private/api_keys#index
#                private_api_key PATCH    /private/api_keys/:id(.:format)                                                          private/api_keys#update
#                                PUT      /private/api_keys/:id(.:format)                                                          private/api_keys#update
#                          about GET      /about(.:format)                                                                         home#about
#                        contact GET      /contact(.:format)                                                                       home#contact
#                     contact_us GET      /contact-us(.:format)                                                                    home#contact
#                list_jobs_admin GET      /list-jobs-admin(.:format)                                                               jobs#list_jobs
#         list_invitations_admin GET      /list-invitations-admin(.:format)                                                        invitations#list_invitations
#                         events GET      /events(.:format)                                                                        home#events
#                     newsletter GET      /newsletter(.:format)                                                                    home#newsletter
#             api_v1_invitations GET      /api/v1/invitations(.:format)                                                            api/v1/invitations#index
#                                POST     /api/v1/invitations(.:format)                                                            api/v1/invitations#create
#                    api_v1_jobs GET      /api/v1/jobs(.:format)                                                                   api/v1/jobs#index
#                     api_v1_job GET      /api/v1/jobs/:id(.:format)                                                               api/v1/jobs#show
#            search_api_v1_users GET      /api/v1/users/search(.:format)                                                           api/v1/users#search
#                   api_v1_users GET      /api/v1/users(.:format)                                                                  api/v1/users#index
#                    api_v1_user GET      /api/v1/users/:id(.:format)                                                              api/v1/users#show
#                           root GET      /                                                                                        home#index
#             rails_service_blob GET      /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#      rails_blob_representation GET      /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#             rails_disk_service GET      /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#      update_rails_disk_service PUT      /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#           rails_direct_uploads POST     /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
#
# Routes for Rswag::Api::Engine:
#
#
# Routes for Rswag::Ui::Engine:
#
#
# Routes for LetterOpenerWeb::Engine:
# clear_letters DELETE /clear(.:format)                 letter_opener_web/letters#clear
# delete_letter DELETE /:id(.:format)                   letter_opener_web/letters#destroy
#       letters GET    /                                letter_opener_web/letters#index
#        letter GET    /:id(/:style)(.:format)          letter_opener_web/letters#show
#               GET    /:id/attachments/:file(.:format) letter_opener_web/letters#attachment

Rails.application.routes.draw do
  mount Rswag::Api::Engine => 'api-docs'
  mount Rswag::Ui::Engine => '/api/v1/api-docs/'
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :partners

  resources :jobs do
    member do
      put :pre_approve
      put :approve
      put :take_down
      get :feedback
    end
  end

  resources :invitations do
    member do
      put :resend
      put :approve
    end
  end

  resources :members, except: [:show, :delete] do
    collection do
      get :news_email_subscribers
      get :jobs_email_subscribers
    end
  end

  scope path: ':user_id', as: 'user' do
    resource :profile do
      get :reload_avatar
    end
  end

  devise_for :users,
              controllers: {
                omniauth_callbacks: 'users/omniauth_callbacks'
              }

  namespace :directory do
    resources :users, only: [:index, :show]
  end
  
  require "admin_constraint"
  constraints AdminConstraint.new do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  namespace :private do
    resource :dashboard, only: [:show]
    resources :api_keys, only: [:index, :update] do
      member do
        put :update_state
        put :update_access
      end
    end
  end

  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'
  get 'contact-us', to: 'home#contact'
  get 'list-jobs-admin', to: 'jobs#list_jobs'
  get 'list-invitations-admin', to: 'invitations#list_invitations'
  get 'events', to: 'home#events'
  get 'newsletter', to: 'home#newsletter'

  # API resources
  namespace :api do
    namespace :v1 do
      resources :invitations, only: [:index, :create]
      resources :jobs, :controller => :jobs, only: [:index, :show]
      resources :users, :controller => :users, only: [:index, :show] do
        collection do
          get :search
        end
      end
    end
  end

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
