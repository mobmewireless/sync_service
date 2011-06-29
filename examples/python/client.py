from jsonrpc import ServiceProxy

client = ServiceProxy("http://127.0.0.1:8080/test_application")

# Get result of an existing method.
print 'Server timestamp is ' + str(client.server_timestamp())

# Get result of a non-existing method via method_missing.
print 'Method missing works: ' + client.plus(1)

# Synchronous error handling.
try:
  client.buggy_method()
except Exception as e:
  print 'EXCEPTION CAUGHT: ' + e.message
  
