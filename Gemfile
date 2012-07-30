source "https://rubygems.org"

gemspec :development_group => :test

if RUBY_VERSION < "1.9.2"
  gem "factory_girl", "< 3.0", :group => :test
  gem "strong_parameters", :git => "git://github.com/rails/strong_parameters.git", :group => :test
else
  gem "strong_parameters"
end

group :development do
  gem "debugger",  :platforms => :mri_19
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "rb-fsevent"
  gem "rdiscount"
  gem "rdoc"
  gem "ruby-debug", :platforms => :mri_18
  gem "spec_coverage", :platforms => :mri_19
  gem "travis-lint"
  gem "yard"
end
