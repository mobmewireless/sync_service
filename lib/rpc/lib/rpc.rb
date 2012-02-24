# encoding: utf-8

module RPC
  module Clients
    autoload :NetHttp, "rpc/clients/net-http"
    autoload :EmHttpRequest, "rpc/clients/em-http-request"
    autoload :Socket, "rpc/clients/socket"
  end

  module Encoders
    autoload :Json, "rpc/encoders/json"
  end

  def self.logging
    @logging ||= $DEBUG
  end

  def self.logging=(boolean)
    @logging = boolean
  end

  def self.log(message)
    STDERR.puts(message) if self.logging
  end

  def self.development=(boolean)
    @development = boolean
  end

  def self.development?
    !! @development
  end

  def self.full_const_get(const_name)
    parts = const_name.sub(/^::/, "").split("::")
    parts.reduce(Object) do |constant, part|
      constant.const_get(part)
    end
  end

  class Server
    def initialize(subject, encoder = RPC::Encoders::Json::Server.new)
      @subject, @encoder = subject, encoder
    end

    def execute(encoded_command)
      @encoder.execute(encoded_command, @subject)
    end
  end

  module ExceptionsMixin
    attr_accessor :server_backtrace

    # NOTE: We can't use super to get the client backtrace,
    # because backtrace is generated only if there is none
    # yet and because we are redefining the backtrace method,
    # there always will be some backtrace.
    def backtrace
      @backtrace ||= begin
        caller(3) + ["... server ..."] + self.server_backtrace
      end
    end
  end

  class Client < BasicObject
    def self.setup(uri, client_class = Clients::NetHttp, encoder = Encoders::Json::Client.new)
      client = client_class.new(uri)
      self.new(client, encoder)
    end

    def initialize(client, encoder = Encoders::Json::Client.new, &block)
      @client, @encoder = client, encoder

      if block
        @client.run do
          block.call(self)
        end
      else
        @client.connect
      end
    end

    def notification(*args)
      data = @encoder.notification(*args)
      @client.send(data)
    end

    def batch(*args)
      data = @encoder.batch(*args)
      @client.send(data)
    end

    # 1) Sync: it'll return the value.
    # 2) Async: you have to add #subscribe

    # TODO: this should be refactored and moved to the encoder,
    # because result["error"] and similar are JSON-RPC-specific.
    def method_missing(method, *args, &callback)
      binary = @encoder.encode(method, *args)

      if @client.async? && ! callback # Assume notification.
        @client.send(binary)
      elsif @client.async? && callback
        @client.send(binary) do |encoded_result|
          result = @encoder.decode(encoded_result)

          if result.respond_to?(:merge) # Hash, only one result.
            callback.call(result["result"], get_exception(result["error"]))
          else # Array, multiple results.
            result.map do |result|
              callback.call(result["result"], get_exception(result["error"]))
            end
          end
        end
      else
        ::Kernel.raise("You can't specify callback for a synchronous client.") if callback

        encoded_result = @client.send(binary)

        if encoded_result.nil?
          ::Kernel.raise("Bug in #{@client.class}#send(data), it can never return nil in the sync mode!")
        end

        result = @encoder.decode(encoded_result)

        if result.respond_to?(:merge) # Hash, only one result.
          result_or_raise(result)
        else # Array, multiple results.
          result.map do |result|
            result_or_raise(result)
          end
        end
      end
    end

    def result_or_raise(result)
      if error = result["error"]
        exception = self.get_exception(error)
        ::Kernel.raise(exception)
      else
        result["result"]
      end
    end

    def get_exception(error)
      return unless error
      exception = error["error"]
      resolved_class = ::RPC.full_const_get(exception["class"])
      klass = resolved_class || ::RuntimeError
      message = resolved_class ? exception["message"] : error["message"]
      case klass.instance_method(:initialize).arity
        when 2
          instance = klass.new(message, nil)
        else
          instance = klass.new(message)
      end
      instance.extend(::RPC::ExceptionsMixin)
      instance.server_backtrace = exception["backtrace"]
      instance
    end

    def close_connection
      @client.disconnect
    end
  end
end
