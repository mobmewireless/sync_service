module MobME
  module Infrastructure
    module RPC
      VERSION = '0.1.1'
      class Adaptor; end
      class Runner; end
      class Base; end
      class Error < StandardError; end
    end
  end
end

# Alias it
SyncService = MobME::Infrastructure::RPC
