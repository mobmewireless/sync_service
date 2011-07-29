lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'mobme/infrastructure/rpc/version'

Gem::Specification.new do |s|
  s.name        = "mobme-infrastructure-rpc"
  s.version     = MobME::Infrastructure::RPC::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["MobME"]
  s.email       = ["engineering@mobme.in"]
  s.homepage    = "http://mobme.in/"
  s.summary     = %q{Generic wrapper for RPC-based services.}
  s.description = %q{RPC is a library that you can use to expose other service classes using JSON-RPC 2.0 specification.}

  s.required_rubygems_version = ">= 1.6.2"

  s.add_development_dependency "rspec"
  s.add_development_dependency "autotest"
  s.add_development_dependency "autotest-notification"
  s.add_development_dependency "rake"
  s.add_development_dependency "simplecov", '>= 0.4.0'
  s.add_development_dependency "simplecov-rcov"

  s.add_dependency "rpc", "= 0.2"
  s.add_dependency "rack"
  s.add_dependency "thin"

  s.files              = `git ls-files`.split("\n") - ["Gemfile.lock", ".rvmrc"]
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths      = ["lib"]
end
