#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)

require "rpc"
require "socket"

require_relative "../helpers"

RPC.logging = true
# RPC.development = true

# Helpers.
def wait_for_client(server_socket)
  # Block for incoming connection from client by accept method.
  # The return value of accept contains the new client socket
  # object and the remote socket address
  client, client_sockaddr = server_socket.accept

  trap(:TERM) { server_socket.close }

  [client, client_sockaddr]
end

server_socket = TCPServer.new("127.0.0.1", 2200)

client, client_sockaddr = wait_for_client(server_socket)

server = RPC::Server.new(RemoteObject.new)

begin
  while data = client.readline.chomp
    result = server.execute(data)
    client.puts(result)
  end
rescue Errno::ECONNRESET, EOFError
  # This occurs when client closes the connection. We can safely ignore it.
  client, client_sockaddr = wait_for_client(server_socket)
  retry
end
