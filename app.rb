require 'sinatra'
require 'sinatra/activerecord'
require 'mechanize'

class WebmentionApp < Sinatra::Base
  set :views, "#{settings.root}/app/views"
end

['helpers', 'models', 'routes'].each do |path|
  Dir.glob("./app/#{path}/*.rb", &method(:require))
end