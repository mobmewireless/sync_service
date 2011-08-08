## Description

This gem provides a base class for JSON-RPC Services, a Rack Adaptor for Rackup compliant servers, and a Runner class
which allows testing using thin server.

## Install

Install rvm and ruby-1.9.2

## Then do:

    $ gem install bundler
    $ bundle install --path vendor [--without linux] [--without osx]
    $ bundle package

## Deployment

mobme-infrastructure-rpc is a gem. Add gems.mobme.in to bundle sources, then require 'mobme-infrastructure-rpc' within
ruby code.
