require 'rspec'

# Local
require_relative '../lib/mobme_infrastructure_rpc_runner'

module MobME::Infrastructure
  describe RPCRunner do
    it "starts thin server" do
      Thin::Server.stub(:start).and_return(nil)
      Thin::Server.should_receive(:start)
    end
  end
end