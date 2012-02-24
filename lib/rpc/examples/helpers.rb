# encoding: utf-8

class RemoteObject
  def server_timestamp
    Time.now.to_i
  end

  def buggy_method
    raise "This exception is expected."
  end

  def method_missing(name, *args)
    "[SERVER] received method #{name} with #{args.inspect}"
  end
end
