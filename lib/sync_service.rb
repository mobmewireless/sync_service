# Standard
require 'syslog'
require 'pathname'

# Gems
require "rack/request"

# Bundled RPC
$:.push(Pathname.new(File.dirname(__FILE__)).join('rpc', 'lib').to_path)
require 'rpc'

# Local
require_relative 'mobme/infrastructure/rpc/version'
require_relative 'mobme/infrastructure/rpc/error'
require_relative 'mobme/infrastructure/rpc/base'
require_relative 'mobme/infrastructure/rpc/adaptor'
require_relative 'mobme/infrastructure/rpc/runner'

# Alias the client too
SyncService::Client = RPC::Client
