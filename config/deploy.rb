set :stages, %w(production)
set :default_stage, 'production'

require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :application, 'webmention.sixtwothree.org'

set :repository, 'git@github.com:jgarber623/webmention.sixtwothree.org.git'
set :deploy_to, '/var/www/webmention.sixtwothree.org'
set :user, 'www-data'
set :deploy_via, :remote_cache
set :ssh_options, {forward_agent: true}
set :use_sudo, false

set :ruby_version, '2.1.1'
set :bundle_cmd, "chruby-exec #{ruby_version} -- bundle"

default_run_options[:shell] = '/bin/bash'

namespace :deploy do
  task :restart do
    # Relaunch the app
  end
end