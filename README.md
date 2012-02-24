## Introduction

sync_service is a library to create synchronous SOA daemons. It's built on top of the JSON/RPC protocol and can be deployed anywhere you deploy a Rack application.

## Hosting a Service

A service is just any Ruby object that descends from SyncService::Base. Any public method in the object is automatically exposed via SOA.


    require "sync_service"

    class Application < SyncService::Base
      @service_name = "mobme.infrastructure.rpc.test"

      def server_timestamp
        Time.now.to_i
      end

      def buggy_method
        raise MobME::Infrastructure::RPC::Error, "This exception is expected."
      end

      def method_missing(name, *args)
        logger.err "[SERVER] received method #{name} with #{args.inspect}"
      end
    end

To expose the Application, you can either create a standalone server and run it via SyncService::Runner, or:

    require 'sync_service'
    require_relative 'application'

    SyncService::Runner.start Application.new, '0.0.0.0', 8080, '/test_application'

or make a simple config.ru via SyncService::Adaptor:

    require 'sync_service'
    require Pathname.new(File.dirname(__FILE__)).join('application')

    map("/test_application") do
      run SyncService::Adaptor.new(Application.new)
    end

## Consuming a Service

To consume services, use SyncService::Client:

    require "sync_service"
    RPC.logging = true

    client = SyncService::Client.setup("http://127.0.0.1:8080/test_application")

    # Get result of an existing method.
    puts "Server timestamp is #{client.server_timestamp}"


You can see the complete example in the examples/ folder.

## Install

Requires ruby-1.9.3p0.

Then do:

    $ gem install bundler
    $ bundle install --path vendor [--without linux] [--without osx]
    $ bundle package


