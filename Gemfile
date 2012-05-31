source "https://rubygems.org"

gemspec :development_group => :test
gem "factory_girl", "< 3.0", :group => :test if RUBY_VERSION < "1.9.2"

group :development do
  gem "validates_timeliness" # Compatibility testing
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
  gem "travis-lint"
  gem "yard"
end
