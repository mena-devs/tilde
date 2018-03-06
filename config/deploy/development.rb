set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
set :user, 'vagrant'
set :use_sudo, false

Rake::Task["deploy:assets:precompile"].clear_actions
Rake::Task["deploy:assets:backup_manifest"].clear_actions

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}/"

server "tilde",
       :roles => %w(app cron db web sidekiq)
