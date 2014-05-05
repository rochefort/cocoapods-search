require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do
  `pod setup` unless File.exist?('~/.cocoapods/repos')
end

task default: :spec
