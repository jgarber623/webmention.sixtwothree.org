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
set :normalize_asset_timestamps, false

set :ruby_version, '2.1.1'
set :bundle_cmd, "chruby-exec #{ruby_version} -- bundle"

default_run_options[:shell] = '/bin/bash'

before 'deploy:create_symlink', 'deploy:precompile_assets'
after 'deploy:create_symlink', 'deploy:symlink_db'

namespace :deploy do
  task :precompile_assets do
    run "cd #{current_path} && RACK_ENV=production #{bundle_cmd} exec rake assets:precompile"
  end

  task :restart do
    deploy.stop
    deploy.start
  end

  task :start do
    run "cd #{current_path} && #{bundle_cmd} exec pumactl -F config/puma.rb start"
  end

  task :stop do
    run "cd #{current_path} && #{bundle_cmd} exec pumactl -F config/puma.rb stop"
  end

  task :symlink_db do
    run "ln -s #{shared_path}/db/webmentions.db #{release_path}/db/webmentions.db"
  end
end