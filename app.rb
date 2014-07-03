require 'sinatra'
require 'sinatra/activerecord'
require 'mechanize'

configure { set :server, :puma }

class WebmentionApp < Sinatra::Base
  set :views, "#{settings.root}/app/views"

  after do
    ActiveRecord::Base.connection.close
  end
end

Dir.glob('./app/**/*.rb', &method(:require))