# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Include tasks from other gems included in your Gemfile
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "airbrussh/capistrano"
require "capistrano/bundler"
require "capistrano/rails"
require "capistrano/mb"
require "capistrano/lets-encrypt"
require "capistrano-nc/nc"
require "whenever/capistrano"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
