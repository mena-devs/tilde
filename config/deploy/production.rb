set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
# set :mb_sidekiq_concurrency, 1

server "46.101.47.134",
       :user => 'root',
       :roles => %w(app cron db web)
