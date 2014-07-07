require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/asset_pipeline'
require 'mechanize'

configure { set :server, :puma }

class WebmentionApp < Sinatra::Base
  set :assets_prefix, %w(app/assets)
  set :views, "#{settings.root}/app/views"

  register Sinatra::AssetPipeline

  after do
    ActiveRecord::Base.connection.close
  end
end

Dir.glob('./app/**/*.rb', &method(:require))