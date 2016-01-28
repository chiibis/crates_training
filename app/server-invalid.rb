# require 'eventmachine'
# require 'em-http'
#
# class RequestHandler <  EM::Connection
#
#   def initialize(q)
#     @queue = q
#     @parser = EM::HttpEncoding
#   end
#
#
#   def post_init
#     super
#     puts "Соединение с сервером"
#   end
#
#
#   def receive_data data
#     puts "recevive data"
#
#     params = @parser.encode_param
#
#     close_connection if data =~ /quit/i
#   end
#
#   def unbind
#     puts "Соединение закрыто"
#   end
# end
#
# EM.run do
#   queue = EM::Queue.new
#   EM.start_server('0.0.0.0', '8181', RequestHandler, queue)
#
#   puts 'Server started on localhost:8181' # Any interface, actually
#
#   process_queue = proc do |url|
#     request = EM::HttpRequest.new(url, connect_timeout: 1).get # No time to wait, sorry
#
#     request.callback do |http| # deferrable
#       puts http.response_header.status
#       EM.next_tick { queue.pop(&process_queue) }
#     end
#
#   end
# end