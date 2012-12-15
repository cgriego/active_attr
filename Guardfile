guard "bundler" do
  watch("Gemfile")
  watch(/^.+\.gemspec/)
end

guard "rspec", :cli => "--format nested --debugger" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| ["spec/unit/#{m[1]}_spec.rb", "spec/functional/#{m[1]}_spec.rb"] }
  watch("spec/spec_helper.rb") { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { |m| "spec" }
end
