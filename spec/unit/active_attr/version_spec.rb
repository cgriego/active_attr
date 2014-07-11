require "spec_helper"
require "active_attr/version"

module ActiveAttr
  describe "ActiveAttr::VERSION" do
    subject { VERSION }

    it { should be_a_kind_of String }

    describe "is compliant with Semantic Versioning <http://semver.org/>" do
      let(:gem_version) { Gem::Version.new VERSION }
      subject(:version) { gem_version }

      it { version.segments.size.should >= 3 }
      it { version.segments.size.should <= 5 }

      describe "major version" do
        subject { gem_version.segments[0] }

        it { should be_a_kind_of Fixnum }
      end

      describe "minor version" do
        subject { gem_version.segments[1] }

        it { should be_a_kind_of Fixnum }
      end

      describe "patch version" do
        subject { gem_version.segments[2] }

        it { should be_a_kind_of Fixnum }
      end

      describe "pre-release version" do
        subject(:pre_release_version) { VERSION.split(".")[3] }

        it "is nil or starts with a letter and is alphanumeric" do
          (pre_release_version.nil? || pre_release_version =~ /^[A-Za-z][0-9A-Za-z]*?/).should == true
        end
      end
    end
  end
end
