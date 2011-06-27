require 'mobme-infrastructure-rpc'

require_relative 'application'

map("/test_application") do
  run MobME::Infrastructure::RPC::Adaptor.new(Application.new)
end
