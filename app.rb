require 'twitter'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

require_relative 'config/extensions'
require_relative 'models/tweet'

set :environment, :development
set :server, 'webrick'

get '/' do
  @tweets = Tweet.all
  erb :index
end
