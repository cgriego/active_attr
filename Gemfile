source "https://rubygems.org"

gemspec :development_group => :test

gem "activemodel",   ">= 5.2.0.beta1", "< 6.1"
gem "activesupport", ">= 5.2.0.beta1", "< 6.1"
gem "actionpack",    ">= 5.2.0.beta1", "< 6.1"
gem "activemodel-serializers-xml", :group => :test
gem "protected_attributes_continued", :group => :test

group :development do
  gem "debugger" if RUBY_VERSION < "2.0"
  gem "byebug" unless RUBY_VERSION < "2.0"
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "rb-fsevent"
  gem "rdiscount"
  gem "rdoc"
  gem "spec_coverage", :git => "https://github.com/getaroom/spec_coverage.git"
  gem "travis"
  gem "yard"
end
