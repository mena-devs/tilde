set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
set :user, 'vagrant'
set :use_sudo, false

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}/"

server "tilde",
       :roles => %w(app cron db web sidekiq)
