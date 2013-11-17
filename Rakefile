require 'fileutils'
require 'rake'
require 'rake/clean'
require 'rspec/core/rake_task'

rspec_opts = []
rspec_opts.push '-c' # color output

RSpec::Core::RakeTask.new(:unit) do |t|
  rspec_opts_local = rspec_opts.dup
  rspec_opts_local.push '--order', 'rand'
  t.rspec_opts = rspec_opts_local
  t.pattern = 'spec/unit/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:integration) do |t|
  rspec_opts_local = rspec_opts.dup
  t.rspec_opts = rspec_opts_local
  file_list = FileList['spec/integration/**/*_spec.rb']
  t.pattern = file_list
end

task :it => :integration
task :spec => [:unit, :integration]
task :default => [:clean, :spec]
