require 'rspec'

# Local
require_relative '../lib/mobme_infrastructure_rpc'

module MobME::Infrastructure::RPC
  describe Runner do
    it "should respond to class method 'run' with 4 arguments" do
      Runner.should respond_to(:start).with(4).arguments
    end

    describe "#run" do
      let(:application) { double("Application") }
      before :each do
        Thin::Server.stub(:start)
      end

      it "starts thin server" do
        Thin::Server.should_receive(:start).with('0.0.0.0', 8080)
        Runner.start(application, '0.0.0.0', 8080, '/application')
      end

#      it "uses Rack::CommonLogger" do
#        RPCRunner.should_receive(:use)
#        RPCRunner.start(application, '0.0.0.0', 8080, '/application')
#      end
    end
  end
end