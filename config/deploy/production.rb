set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
# set :mb_sidekiq_concurrency, 1

server "188.166.159.103",
       :user => 'rails',
       :roles => %w(app cron db web)
      #  :roles => %w(app backup cron db redis sidekiq web)
