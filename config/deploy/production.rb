set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
# set :mb_sidekiq_concurrency, 1

server "menadevs.com",
       :user => 'root',
       :roles => %w(app cron db web sidekiq)
