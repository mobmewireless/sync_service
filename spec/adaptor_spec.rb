# Gems
require 'rspec'

# Local
require_relative '../lib/mobme-infrastructure-rpc'

module MobME::Infrastructure::RPC
  describe Adaptor do
    let(:dummy_service_object) { double "DummyService" }
    let(:dummy_server) { double(RPC::Server).as_null_object }

    before :each do
      RPC::Server.stub(:new).and_return(dummy_server)
    end

    subject { Adaptor.new dummy_service_object }

    it "accepts service object" do
      Adaptor.should respond_to(:new).with(1).argument
      Adaptor.new dummy_service_object
    end

    it { should respond_to(:server).with(0).arguments }
    it { should respond_to(:call).with(1).argument }
    it { should respond_to(:response).with(2).arguments }

    describe "#server" do
      it "creates an instance of RPC::Server" do
        RPC::Server.should_receive(:new).with(dummy_service_object)
        subject.server
      end

      it "returns an instance of RPC::Server" do
        subject.server.should be dummy_server
      end

      context "when called multiple times" do
        it "returns the same (original) instance of RPC::Server" do
          subject.server.should be dummy_server
          second_dummy_server = double(RPC::Server)
          RPC::Server.stub(:new).and_return(second_dummy_server)
          subject.server.should be dummy_server
        end
      end
    end

    describe "#call" do
      let(:dummy_environment) { double("Environment") }
      let(:dummy_command) { double("Request Command") }
      let(:dummy_body) { double("Request Body", :read => dummy_command) }
      let(:dummy_request) { double(Rack::Request, :body => dummy_body) }

      before :each do
        Rack::Request.stub(:new).and_return(dummy_request)
        subject.stub(:response)
      end

      it "creates a new rack request object" do
        Rack::Request.should_receive(:new).with(dummy_environment)
        subject.call(dummy_environment)
      end

      it "extracts command from request" do
        dummy_request.should_receive(:body)
        dummy_body.should_receive(:read)
        subject.call(dummy_environment)
      end

      it "executes the extracted command" do
        dummy_server.stub(:execute).and_return(double("Binary Response").as_null_object)
        dummy_server.should_receive(:execute).with(dummy_command)
        subject.call(dummy_environment)
      end

      context "when response from executed command contains string NoMethodError" do
        it "calls response method with status 404" do
          dummy_server.stub(:execute).and_return('NoMethodError')
          subject.should_receive(:response).with(404, 'NoMethodError')
          subject.call(dummy_environment)
        end
      end

      context "when response from executed command does not contain NoMethodError" do
        it "calls response method with status 200" do
          dummy_server.stub(:execute).and_return('Method Exists!')
          subject.should_receive(:response).with(200, 'Method Exists!')
          subject.call(dummy_environment)
        end
      end
    end

    describe "#response" do
      it "returns response array acceptable to Rack" do
        dummy_body = "Dummy Body Content"
        headers = {
          "Content-Type" => "application/json-rpc",
          "Content-Length" => dummy_body.bytesize.to_s
        }
        subject.response(200, dummy_body).should == [200, headers, [dummy_body]]
      end
    end
  end
end