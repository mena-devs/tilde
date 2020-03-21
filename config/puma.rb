workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
bind  "unix://#{app_dir}/puma.sock"
pidfile "#{app_dir}/puma.pid"
state_path "#{app_dir}/puma.state"
directory "#{app_dir}/"

stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

activate_control_app "unix://#{app_dir}/pumactl.sock"

prune_bundler

on_worker_boot do
  ActiveRecord::Base.establish_connection

  if defined?(Resque)
    Resque.redis = ENV["<redis-uri>"] || "redis://127.0.0.1:6379"
 end
end