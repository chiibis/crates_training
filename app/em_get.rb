require 'eventmachine'

class EmGet

  def initialize(url)
    @url = url
  end

  def greet
    "Hello #{@url}"
  end

  def perform
    # EventMachine.run {
    #   http = EventMachine::HttpRequest.new('http://google.com/').get :query => {'keyname' => 'value'}
    #
    #   http.errback { p 'Uh oh'; EM.stop }
    #   http.callback {
    #     p http.response_header.status
    #     p http.response_header
    #     p http.response
    #
    #     EventMachine.stop
    #   }
    # }
  end
end