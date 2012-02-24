module MobME
  module Infrastructure
    module RPC
      VERSION = '0.0.8'
      class Adaptor; end
      class Runner; end
      class Base; end
      class Error < StandardError; end
    end
  end
end

# Alias it
SyncService = MobME::Infrastructure::RPC
