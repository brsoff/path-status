require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

require_relative 'config/environments'

require_relative 'models/tweet'

set :environment, :development

get '/' do
  erb :index
end


