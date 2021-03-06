require "sync_service"

RPC.logging = true

client = SyncService::Client.setup("http://127.0.0.1:8080/test_application")

# Get result of an existing method.
puts "Server timestamp is #{client.server_timestamp}"

# Missing methods raise an error..
puts "Method missing works: #{client + 1}" rescue nil

# Synchronous error handling.
begin
  client.buggy_method
rescue MobME::Infrastructure::RPC::Error => exception
  STDERR.puts "EXCEPTION CAUGHT: #{exception.inspect}"
end

# Notification isn't supported, because HTTP works in
# request/response mode, so it does behave in the same
# manner as rpc via method_missing. Sense of this is
# only to check, that it won't blow up.
puts "Sending a notification ..."
client.notification(:log, "Some shit.")

# Batch.
result = client.batch([[:log, ["Message"], nil], [:a_method, []]])
puts "Batch result: #{result}"
