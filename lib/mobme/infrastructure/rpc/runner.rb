module MobME::Infrastructure::RPC
  class Runner
    def self.start(application, host, port, route)
      Thin::Server.start(host, port) do
        use Rack::CommonLogger

        map route do
          run Adaptor.new(application)
        end
      end
    end
  end
end