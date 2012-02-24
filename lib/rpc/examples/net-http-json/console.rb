#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)

require "rpc"
require "irb"

@client = RPC::Client.setup("http://127.0.0.1:8081")

puts "~ RPC Client initialised, use @client to access it."

IRB.start(__FILE__)
