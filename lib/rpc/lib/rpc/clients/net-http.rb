# encoding: utf-8

require "uri"

# Note that we support only HTTP POST. JSON-RPC can be done
# via HTTP GET as well, but since HTTP POST is the preferred
# method, I decided to implement only it. More info can is here:
# http://groups.google.com/group/json-rpc/web/json-rpc-over-http

module Net
  autoload :HTTP,  "net/http"
  autoload :HTTPS, "net/https"
end

module RPC
  module Clients
    class NetHttp
      HEADERS ||= {"Accept" => "application/json-rpc"}

      def initialize(uri)
        @uri = URI.parse(uri)
        klass = Net.const_get(@uri.scheme.upcase)
        @client = klass.new(@uri.host, @uri.port)
      end

      def connect
        @client.start
      end

      def disconnect
        @client.finish
      end

      def run(&block)
        self.connect
        block.call
        self.disconnect
      end

      def send(data)
        path = @uri.path.empty? ? "/" : @uri.path

        begin
          @client.post(path, data, HEADERS).body
        rescue EOFError
          retry
        end
      end

      def async?
        false
      end
    end
  end
end
