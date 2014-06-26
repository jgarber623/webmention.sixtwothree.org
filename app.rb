require 'sinatra'
require 'sinatra/activerecord'
require 'mechanize'

configure { set :server, :puma }

class WebmentionApp < Sinatra::Base
  set :views, "#{settings.root}/app/views"
end

Dir.glob('./app/**/*.rb', &method(:require))