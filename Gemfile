source "http://rubygems.org"

gemspec :development_group => :test

group :development do
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "rb-fsevent"
  gem "rdiscount"
  gem "rdoc"
  gem "ruby-debug",    :platforms => :mri_18
  gem "ruby-debug19",  :platforms => :mri_19 if RUBY_VERSION < "1.9.3"
  gem "spec_coverage", :platforms => :mri_19
  gem "yard"
  gem 'travis-lint'
end
