require 'twitter'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

require_relative 'config/extensions'
require_relative 'config/helpers'
require_relative 'models/tweet'

set :environment, :development
set :server, 'webrick'
set :partial_template_engine, :erb
enable :partial_underscores

get '/' do
  days = params[:days] || 14

  @timeline = Tweet.timeline(days.to_i)
  @stats = Tweet.stats(@timeline).to_a

  params[:days] ? (erb :index, layout: false) : (erb :index)
end
