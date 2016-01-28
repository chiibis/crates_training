require_relative 'postgress_adapter'
require_relative 'training_server'

require 'eventmachine'


EM.run do
  urls = EM::Queue.new
  pg = PostgressAdapter.new

  # define app params
  server  = 'thin'
  host    = '0.0.0.0'
  port    = '8181'
  web_app = TrainingServer.new(urls)

  dispatch = Rack::Builder.app do
    map '/' do
      run web_app
    end
  end

  # Start the web server.
  Rack::Server.start({
                         app:    dispatch,
                         server: server,
                         Host:   host,
                         Port:   port,
                         signals: false,
                     })

  process_queue = proc do |url|
    request = EM::HttpRequest.new(url, connect_timeout: 1).get # No time to wait

    request.callback do |http| # deferrable
      pg.log_request http.response_header.status
      EM.next_tick { urls.pop(&process_queue) }
    end

    request.errback do
      # urls.push(url)
    end

  end

  EM.next_tick { urls.pop(&process_queue) }

end