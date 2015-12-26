require 'sinatra'
require_relative 'em_get'

get '/send' do
  puts "Get API request with params: = #{params}"
  em_send(params[:url]) if params[:url]
  status 200
end

not_found do
  status 404
  "Page not available. Please, use /send?url="
end

def em_send(url)
  req = EmGet.new(url)
  req.perform
end

