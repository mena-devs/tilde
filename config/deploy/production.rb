set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
set :mb_sidekiq_concurrency, 1

server "138.68.149.87",
       :user => "deployer",
       :roles => %w(app backup cron db redis sidekiq web)
