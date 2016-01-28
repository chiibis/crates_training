require 'em-http'
require 'sinatra/base'
require 'thin'
require 'json'

class TrainingServer < Sinatra::Base

  def initialize(em_queue)
    @queue = em_queue
    @pg = PostgressAdapter.new
    super
  end

  configure do
    # Will take requests on the reactor thread
    set :threaded, false
  end

  get '/stats' do
    # send_file 'app/html/stats.html'
    # "Requests: \n TOTAL: #{@pg.total_count} \n SUCCESSFUL: #{@pg.successful_count}, \nFAILED: #{@pg.failed_count}"
    content_type :json
    { successful: @pg.successful_count , failed: @pg.failed_count, total: @pg.total_count}.to_json
  end

  # Request runs on the reactor thread (with threaded set to false)
  get '/send' do
    # puts "Get API request with params: = #{params}"
    not_found if params[:url].nil?
    @queue.push(params[:url])

    status 200
    "New queue length: #{@queue.size}"
  end

  get "/favicon.ico" do
  end

  not_found do
    status 404
    "Page not available"
  end

end