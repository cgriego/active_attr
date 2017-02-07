source "https://rubygems.org"

gemspec :development_group => :test

gem "activemodel",   "~> 5.0.0"
gem "activesupport", "~> 5.0.0"
gem "actionpack",    "~> 5.0.0", :group => :test
gem "activemodel-serializers-xml", :group => :test
gem "protected_attributes_continued", :group => :test

group :development do
  gem "debugger", :platforms => :mri_19
  gem "byebug", :platforms => [:mri_20, :mri_21, :mri_22, :mri_23, :mri_24]
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "rb-fsevent"
  gem "rdiscount"
  gem "rdoc"
  gem "ruby-debug", :platforms => :mri_18
  gem "spec_coverage", :platforms => [:mri_19, :mri_20, :mri_21, :mri_22, :mri_23, :mri_24], :git => "https://github.com/getaroom/spec_coverage.git"
  gem "travis"
  gem "yard"
end
