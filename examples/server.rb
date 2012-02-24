require 'sync_service'
require_relative 'application'

SyncService::Runner.start Application.new, '0.0.0.0', 8080, '/test_application'