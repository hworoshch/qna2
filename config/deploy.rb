# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "qna"
set :repo_url, "git@github.com:hworoshch/qna2.git"
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"
set :rvm_type, :user
set :rvm_ruby_version, "2.7.2"

set :init_system, :systemd
set :service_unit_name, "sidekiq"

append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"
