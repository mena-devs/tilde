set :branch, ENV.fetch("CAPISTRANO_BRANCH", "master")
set :mb_sidekiq_concurrency, 1

set :deploy_to, "/var/www/menadevs"
set :whenever_path, ->{ release_path }

server "beta.menadevs.com",
       :user => "deployer",
       :roles => %w(app backup cron db redis sidekiq web)

set :mb_postgresql_database, 'tilde_production'
set :mb_postgresql_user, 'menadevs_user'
set :mb_postgresql_password, 'tz4\!r7PYiohHfFzk'

# LETS_ENCRYPT CONFIG VALUES
# Set the roles where the let's encrypt process should be started
# Be sure at least one server has primary: true
# default value: :web
set :lets_encrypt_roles, :lets_encrypt

# Set it to true to use let's encrypt staging servers
# default value: false
set :lets_encrypt_test, true

# Set your let's encrypt account email (required)
# The account will be created if no private key match
# default value: nil
set :lets_encrypt_email, 'accounts@menadevs.com'

# Set the path to your let's encrypt account private key
# default value: "#{fetch(:lets_encrypt_email)}.account_key.pem"
set :lets_encrypt_account_key, "#{fetch(:lets_encrypt_email)}.account_key.pem"

# Set the domains you want to register (required)
# This must be a string of one or more domains separated a space - e.g. "example.com example2.com"
# default value: nil
set :lets_encrypt_domains, 'menadevs.com'

# Set the path from where you are serving your static assets
# default value: "#{release_path}/public"
set :lets_encrypt_challenge_public_path, "#{release_path}/public"

# Set the path where the new certs are going to be saved
# default value: "#{shared_path}/ssl/certs"
set :lets_encrypt_output_path, "#{shared_path}/ssl/certs"

# Set the local path where the certs will be saved
# default value: "~/certs"
set :lets_encrypt_local_output_path, "~/certs"

# Set the minimum time that the cert should be valid
# default value: 30
set :lets_encrypt_days_valid, 15

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }