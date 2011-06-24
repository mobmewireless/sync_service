module MobME::Infrastructure
  class RPCAdaptor
    def initialize(service_object)
      @service_object = service_object
    end

    def server
      @server ||= RPC::Server.new(@service_object)
    end

    def call(env)
      request = Rack::Request.new(env)
      command = request.body.read
      binary = server.execute(command)

      if binary.match(/NoMethodError/)
        response(404, binary)
      else
        response(200, binary)
      end
    end

    def response(status, body)
      headers = {
        "Content-Type" => "application/json-rpc",
        "Content-Length" => body.bytesize.to_s
      }
      [status, headers, [body]]
    end
  end
end