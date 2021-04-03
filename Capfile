# Load DSL and set up stages
require "capistrano/setup"
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
# require 'capistrano/passenger'
require 'capistrano/sidekiq'
install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd
require 'thinking_sphinx/capistrano'
require 'whenever/capistrano'
require 'capistrano3/unicorn'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
