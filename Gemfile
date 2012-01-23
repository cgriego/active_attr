source "http://rubygems.org"

gemspec :development_group => :test

# temporary workaround since 3.2.0 is incompatible with default rubygems for REE
# https://github.com/rails/rails/issues/4559
git "git://github.com/rails/rails.git", :branch => "3-2-stable" do
  gem "activemodel"
  gem "activesupport"
end

group :development do
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "rb-fsevent"
  gem "rdiscount"
  gem "rdoc", "~> 3.9.4"
  gem "ruby-debug",    :platforms => :mri_18
  gem "ruby-debug19",  :platforms => :mri_19 if RUBY_VERSION < "1.9.3"
  gem "spec_coverage", :platforms => :mri_19
  gem "yard"
end
