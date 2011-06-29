class Application < MobME::Infrastructure::RPC::Base

  @service_name = "mobme.infrastructure.rpc.test"

  def server_timestamp
    Time.now.to_i
  end

  def buggy_method
    raise MobME::Infrastructure::RPC::Error, "This exception is expected."
  end

  def method_missing(name, *args)
    logger.err "[SERVER] received method #{name} with #{args.inspect}"
  end
end