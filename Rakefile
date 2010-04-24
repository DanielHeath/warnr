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

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "warnr"
    gemspec.summary = "Non-fatal rails 3 validations (ie, warnings rather than errors)"
    gemspec.description = <<EOF
Ernr builds on the power of Rails 3 validations.
It lets you use validations to identify situations which are warnings rather than errors.
It also lets you define a callback on the model which is executed after save if there are any warnings.
EOF
    gemspec.email = "daniel.heath@gmail.com"
    gemspec.homepage = "http://github.com/DanielHeath/warnr"
    gemspec.authors = ["Daniel Heath"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

