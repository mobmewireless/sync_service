# Bundler
require 'bundler/setup'

# Gems
require "rack/request"
require 'rpc'
require 'thin'

# Local
require 'mobme/infrastructure/version'
require 'mobme/infrastructure/rpc_adaptor'
require 'mobme/infrastructure/rpc_runner'