#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)

require "rpc"

RPC.logging = true

# TODO: the second argument could be +/- guessed (amqp -> amqp adapter, ip -> socket)
# TODO: IP isn't any existing URI scheme, on the other hand there are so many not existing URI schemes today that I don't think it matters (rsync://, git://, javascript:// and I could go on)
client = RPC::Client.setup("ip://localhost:2200", RPC::Clients::Socket)

# Get result of an existing method.
puts "Server timestamp is #{client.server_timestamp}"

# Get result of a non-existing method via method_missing.
puts "Method missing works: #{client + 1}"

# Synchronous error handling.
begin
  client.buggy_method
rescue Exception => exception
  STDERR.puts "EXCEPTION CAUGHT: #{exception.inspect}"
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
