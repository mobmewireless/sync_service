module MobME::Infrastructure::RPC
  class Base
    def self.service_name
      @service_name
    end

    def logger
      unless Syslog.opened?
        Syslog.open(self.class.service_name, Syslog::LOG_PID | Syslog::LOG_CONS)
      end

      Syslog
    end
  end
end