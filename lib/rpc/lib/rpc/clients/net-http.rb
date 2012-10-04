# encoding: utf-8

require "uri"
require 'persistent_http'

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
        @klass = Net.const_get(@uri.scheme.upcase)

        @client = PersistentHTTP.new(
          pool_size: 5,
          force_retry: true,
          url: @uri
        )
      end

      def run(&block)
        block.call
      end

      def send(data)
        path = @uri.path.empty? ? "/" : @uri.path
        request = @klass::Post.new path
        request.body = data
        response = @client.request(request)
        response.body
      end

      def async?
        false
      end
    end
  end
end
