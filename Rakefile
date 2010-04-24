require 'rake'
require 'rubygems'

require 'spec/rake/spectask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Generate documentation for the warner plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Warnr'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/*.rb')
end

desc 'Test the warner plugin.'
Spec::Rake::SpecTask.new('test') do |t|
  t.spec_files = FileList['spec/*.rb']
end
