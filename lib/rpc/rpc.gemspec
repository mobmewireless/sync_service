#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = "rpc"
  s.version = "0.3.1"
  s.authors = ["Jakub Stastny aka botanicus"]
  s.homepage = "http://github.com/ruby-amqp/rpc"
  s.summary = "Generic RPC library for Ruby."
  s.description = "#{s.summary} Currently it supports JSON-RPC over HTTP, support for AMQP and Redis will follow soon."
  s.cert_chain = []
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")

  begin
    require "changelog"
  rescue LoadError
    warn "You have to have changelog gem installed for post install message"
  else
    s.post_install_message = CHANGELOG.new.version_changes
  end

  # RubyForge
  s.rubyforge_project = "rpc"
end
