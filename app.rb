require 'active_support/all'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/asset_pipeline'
require 'sinatra/content_for'
require 'sinatra/json'
require 'sinatra/namespace'
require 'mechanize'
require 'microformats2'

configure { set :server, :puma }

Dir.glob('./config/initializers/*.rb', &method(:require))

class WebmentionApp < Sinatra::Base
  set :views, "#{settings.root}/app/views"

  set :assets_css_compressor, :sass
  set :assets_precompile, %w(application.css)
  set :assets_prefix, %w(app/assets)

  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

  register Sinatra::AssetPipeline
  register Sinatra::Namespace

  after do
    ActiveRecord::Base.connection.close
  end
end

Dir.glob('./app/**/*.rb', &method(:require))