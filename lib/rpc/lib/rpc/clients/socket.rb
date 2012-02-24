# encoding: utf-8

require "uri"
require "socket"

module RPC
  module Clients
    class Socket
      def initialize(uri)
        @uri = URI.parse(uri)

        # Localhost doesn't work for me for some reason.
        @uri.host = "127.0.0.1" if @uri.host.eql?("localhost")
      end

      def connect
        @client = TCPSocket.new(@uri.host, @uri.port)
      rescue Errno::ECONNREFUSED
        raise Errno::ECONNREFUSED.new("You have to start the server first!")
      end

      def disconnect
        @client.close
      end

      def run(&block)
        self.connect
        block.call
        self.disconnect
      end

      # TODO: support for notifications, probably refactor send to:
      # def send(encoder, data)
      #   binary = encoder.encode(data)
      #   @client.puts(binary)
      #   @client.readline if data[:id]
      # end
      # ... and don't forget to add support for notifications to the example socket server!
      def send(data)
        @client.puts(data)
        @client.readline
        # TODO: sync vs. async: @socket.read or a callback and a loop
      end

      def async?
        false
      end
    end
  end
end
