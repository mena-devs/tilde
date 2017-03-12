set :application, "menadevs"
set :repo_url, "git@bitbucket.org:menadevs/menadevs.git"

# Project-specific overrides go here.
# For list of variables that can be customized, see:
# https://github.com/mattbrictson/capistrano-mb/blob/master/lib/capistrano/tasks/defaults.rake

# fetch(:mb_recipes) << "sidekiq"
# fetch(:mb_aptitude_packages)["redis-server@ppa:rwky/redis"] = :redis

set :deploy_to, "/home/menadevs/"
set :branch, "master"
set :deploy_via, :copy

set :mb_dotenv_keys, %w(
  rails_secret_key_base
)

# postmark_api_key
# sidekiq_web_username
# sidekiq_web_password
after "deploy:published", "bundler:clean"

# Default value for :linked_files is []
append :linked_files, "config/settings.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, %w{log}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3
