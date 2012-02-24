#!/usr/bin/env rackup --port 8081
# encoding: utf-8

# http://groups.google.com/group/json-rpc/web/json-rpc-over-http

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "rpc"
require "rack/request"

require_relative "helpers"

RPC.logging = true
# RPC.development = true

class RpcRunner
  def server
    @server ||= RPC::Server.new(RemoteObject.new)
  end

  def call(env)
    request = Rack::Request.new(env)
    command = request.body.read
    binary  = self.server.execute(command)
    if binary.match(/NoMethodError/)
      response(404, binary)
    else
      response(200, binary)
    end
  end

  def response(status, body)
    headers = {
      "Content-Type" => "application/json-rpc",
      "Content-Length" => body.bytesize.to_s}
    [status, headers, [body]]
  end
end

map("/") do
  run RpcRunner.new
end
