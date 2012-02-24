# encoding: utf-8

# http://en.wikipedia.org/wiki/JSON-RPC

begin
  require "yajl/json_gem"
rescue LoadError
  require "json"
end

module RPC
  module Encoders
    module Json
      # This library works with JSON-RPC 2.0
      # http://groups.google.com/group/json-rpc/web/json-rpc-2-0
      JSON_RPC_VERSION ||= "2.0"

      # http://json-rpc.org/wd/JSON-RPC-1-1-WD-20060807.html#ErrorObject
      module Errors
        # @note The exceptions are "eaten", because no client should be able to shut the server down.
        def exception(exception, code = 000, message = "#{exception.class}: #{exception.message}")
          unless RPC.development?
            object = {class: exception.class.to_s, message: exception.message, backtrace: exception.backtrace}
            self.error(message, code, object)
          else
            raise exception
          end
        end

        def error(message, code, object)
          error = {name: "JSONRPCError", code: code, message: message, error: object}
          RPC.log "ERROR #{message} (#{code}) #{error[:error].inspect}"
          error
        end
      end

      class Request
        attr_reader :data
        def initialize(method, params, id = self.generate_id)
          @data = {jsonrpc: JSON_RPC_VERSION, method: method, params: params}
          @data.merge!(id: id) unless id.nil?
        end

        def generate_id
          rand(999_999_999_999)
        end
      end

      class Client
        include Errors

        def encode(method, *args)
          data = Request.new(method, args).data
          RPC.log "CLIENT ENCODE #{data.inspect}"
          data.to_json
        end

        # Notifications are calls which don't require response.
        # They look just the same, but they don't have any id.
        def notification(method, *args)
          data = Request.new(method, args, nil).data
          RPC.log "CLIENT ENCODE NOTIFICATION #{data.inspect}"
          data.to_json
        end

        # Provide list of requests and notifications to run on the server.
        #
        # @example
        #   ["list", ["/"], ["clear", "logs", nil]]
        def batch(requests)
          data = requests.map { |request| Request.new(*request).data }
          RPC.log "CLIENT ENCODE BATCH #{data.inspect}"
          data.to_json
        end

        # TODO: support batch
        def decode(binary)
          if binary.nil?
            raise TypeError.new("#{self.class}#decode takes binary data as an argument, not nil!")
          end

          object = JSON.parse(binary)
          RPC.log "CLIENT DECODE #{object.inspect}"
          object
        rescue JSON::ParserError => error
          self.exception(error, -32600, "Invalid Request.")
        end
      end

      class Server
        include Errors

        def decode(binary)
          object = JSON.parse(binary)
          RPC.log "SERVER DECODE #{object.inspect}"
          object
        rescue JSON::ParserError => error
          # This is supposed to result in HTTP 500.
          raise self.exception(error, -32700, "Parse error.")
        end

        def execute(encoded_result, subject)
          result = self.decode(encoded_result)

          if result.respond_to?(:merge) # Hash, only one result.
            self.encode(result_or_error(subject, result))
          else # Array, multiple results.
            self.encode(
              result.map do |result|
                result_or_error(subject, result)
              end
            )
          end
        end

        def result_or_error(subject, command)
          method, args = command["method"], command["params"]
          result = subject.send(method, *args)
          self.response(result, nil, command["id"])
        rescue NoMethodError => error
          error = self.exception(error, -32601, "Method not found.")
          self.response(nil, error, command["id"])
        rescue ArgumentError => error
          error = self.exception(error, -32602, "Invalid params.")
          self.response(nil, error, command["id"])
        rescue Exception => exception
          error = self.exception(exception)
          self.response(nil, error, command["id"])
        end

        def response(result, error, id)
          {jsonrpc: JSON_RPC_VERSION, result: result, error: error, id: id}
        end

        def encode(response)
          RPC.log "SERVER ENCODE: #{response.inspect}"
          response.to_json
        end
      end
    end
  end
end
