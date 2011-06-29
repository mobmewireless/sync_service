require "rspec"

module MobME::Infrastructure::RPC
  describe Error do
    it "inherits from StandardError" do
      Error.superclass.should == StandardError
    end
  end
end