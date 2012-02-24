require 'sync_service'

require Pathname.new(File.dirname(__FILE__)).join('application')

map("/test_application") do
  run SyncService::Adaptor.new(Application.new)
end
