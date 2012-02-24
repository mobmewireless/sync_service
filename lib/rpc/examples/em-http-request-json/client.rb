#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)

require "rpc"

RPC.logging = true

client = RPC::Clients::EmHttpRequest.new("http://127.0.0.1:8081")

RPC::Client.new(client) do |client|
  # Get result of an existing method.
  client.server_timestamp do |result, error|
    puts "Server timestamp is #{result}"
  end

  # Get result of a non-existing method via method_missing.
  client.send(:+, 1) do |result, error|
    puts "Method missing works: #{result}"
  end

  # Synchronous error handling.
  client.buggy_method do |result, error|
    STDERR.puts "EXCEPTION CAUGHT:"
    STDERR.puts "#{error.class} #{error.message}"
  end

  # Notification isn't supported, because HTTP works in
  # request/response mode, so it does behave in the same
  # manner as RPC via method_missing. Sense of this is
  # only to check, that it won't blow up.
  puts "Sending a notification ..."
  client.notification(:log, "Some shit.")

  # Batch.
  result = client.batch([[:log, ["Message"], nil], [:a_method, []]])
  puts "Batch result: #{result}"
end
