require "sync_service"

class Application < SyncService::Base
  @service_name = "mobme.infrastructure.rpc.test"

  def server_timestamp
    Time.now.to_i
  end

  def buggy_method
    raise MobME::Infrastructure::RPC::Error, "This exception is expected."
  end
end