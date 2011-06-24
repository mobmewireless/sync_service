require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :rcov do
  `rcov -Ilib -xgem,jsignal_internal,_spec.rb spec/*`
end
