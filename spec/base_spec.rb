# Gems
require 'rspec'

# Local
require_relative '../lib/mobme-infrastructure-rpc'

module MobME::Infrastructure::RPC
  class DummyRPCService < Base
    @service_name = "mobme.infrastructure.dummy.rpc.service"
  end

  describe Base do
    it "possesses a service_name class method" do
      Base.should respond_to(:service_name)
    end
  end

  describe DummyRPCService do

    it { should respond_to(:logger) }

    before(:each) do
      if Syslog.opened?
        Syslog.close
      end
    end

    describe "#self.service_name" do
      it "returns the service name assigned to the class" do
        subject.class.service_name.should == "mobme.infrastructure.dummy.rpc.service"
      end
    end

    describe "#logger" do
      it "checks whether Syslog is already open" do
        Syslog.should_receive(:opened?)
        subject.logger
      end

      context "when Syslog is not open" do
        it "opens Syslog with service name" do
          Syslog.should_receive(:open).with(subject.class.service_name, Syslog::LOG_PID | Syslog::LOG_CONS)
          subject.logger
        end
      end

      context "when Syslog is already open" do
        it "does not attempt to open Syslog" do
          Syslog.open(subject.class.service_name, Syslog::LOG_PID | Syslog::LOG_CONS)
          Syslog.should_not_receive(:open)
          subject.logger
        end
      end

      it "returns Syslog" do
        subject.logger.should be Syslog
      end
    end
  end
end