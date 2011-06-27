require_relative '../lib/mobme_infrastructure_rpc'
require_relative 'application'

MobME::Infrastructure::RPC::Runner.start Application.new, '0.0.0.0', 8080, '/test_application'