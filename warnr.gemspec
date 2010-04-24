# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{warnr}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Heath"]
  s.date = %q{2010-04-24}
  s.description = %q{Ernr builds on the power of Rails 3 validations.
It lets you use validations to identify situations which are warnings rather than errors.
It also lets you define a callback on the model which is executed after save if there are any warnings.
}
  s.email = %q{daniel.heath@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "init.rb",
     "install.rb",
     "lib/warnr.rb",
     "rdoc/classes/ActiveRecord.html",
     "rdoc/classes/ActiveRecord/Validations.html",
     "rdoc/classes/ActiveRecord/Validations/InstanceMethods.html",
     "rdoc/classes/Warnr.html",
     "rdoc/classes/Warnr/ClassMethods.html",
     "rdoc/created.rid",
     "rdoc/files/README.html",
     "rdoc/files/lib/warnr_rb.html",
     "rdoc/fr_class_index.html",
     "rdoc/fr_file_index.html",
     "rdoc/fr_method_index.html",
     "rdoc/index.html",
     "rdoc/rdoc-style.css",
     "spec/spec_helper.rb",
     "spec/warnr_spec.rb",
     "uninstall.rb",
     "warnr.gemspec"
  ]
  s.homepage = %q{http://github.com/DanielHeath/warnr}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Non-fatal rails 3 validations (ie, warnings rather than errors)}
  s.test_files = [
    "spec/warnr_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

