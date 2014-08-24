require 'twitter'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/partial'

require_relative 'config/extensions'
require_relative 'config/helpers'
require_relative 'models/tweet'

set :environment, :development
set :server, 'webrick'
set :partial_template_engine, :erb
enable :partial_underscores

get '/' do
  @timeline = Tweet.timeline(14)
  @stats = Tweet.stats(@timeline)
  erb :index
end
