require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/asset_pipeline'
require 'sinatra/content_for'
require 'mechanize'

configure { set :server, :puma }

class WebmentionApp < Sinatra::Base
  helpers Sinatra::ContentFor

  set :views, "#{settings.root}/app/views"

  set :assets_css_compressor, :sass
  set :assets_precompile, %w(application.css)
  set :assets_prefix, %w(app/assets)

  register Sinatra::AssetPipeline

  after do
    ActiveRecord::Base.connection.close
  end
end

Dir.glob('./app/**/*.rb', &method(:require))