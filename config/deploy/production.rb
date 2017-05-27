set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
# set :mb_sidekiq_concurrency, 1

server "production.example.com",
       :user => 'deployer',
       :roles => %w(app cron db web)
