# encoding: utf-8

# https://github.com/eventmachine/em-http-request

require "eventmachine"
require "em-http-request"

# Note that we support only HTTP POST. JSON-RPC can be done
# via HTTP GET as well, but since HTTP POST is the preferred
# method, I decided to implement only it. More info can is here:
# http://groups.google.com/group/json-rpc/web/json-rpc-over-http

module RPC
  module Clients
    class EmHttpRequest
      HEADERS ||= {"Accept" => "application/json-rpc"}

      def initialize(uri)
        @client = EventMachine::HttpRequest.new(uri)
        @in_progress = 0
      end

      def connect
      end

      def disconnect
      end

      def run(&block)
        EM.run do
          block.call

          # Note: There's no way how to stop the
          # reactor when there are no remaining events.
          EM.add_periodic_timer(0.1) do
            EM.stop if @in_progress == 0
          end
        end
      end

      def send(data, &callback)
        request = @client.post(head: HEADERS, body: data)
        @in_progress += 1
        request.callback do |response|
          if callback
            callback.call(response.response)
          end

          @in_progress -= 1
        end
      end

      def async?
        true
      end
    end
  end
end
