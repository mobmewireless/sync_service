# Gems
require "rspec"

# Local
require_relative 'spec_helper'
require_relative '../lib/sync_service'

module SyncService
  describe Error do
    it "inherits from StandardError" do
      Error.superclass.should == StandardError
    end
  end
end