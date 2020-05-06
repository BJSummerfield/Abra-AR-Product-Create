require 'sinatra'
require './data/Generate.rb'
require './data/ProductWrite.rb'
require './.env.rb'

get '/' do
  item = Generate.write(params)
  url = ProductWrite.write(item)
  redirect "#{url}"
end
