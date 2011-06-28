module MobME::Infrastructure::RPC
  class Runner
    def self.start(application, host, port, route)
      Thin::Server.start(host, port) do
        # Since no logger is specified, this will log apache-style strings to STDERR for each request.
        use Rack::CommonLogger

        map route do
          run Adaptor.new(application)
        end
      end
    end
  end
end