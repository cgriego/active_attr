require "spec_helper"
require "active_attr/version"

module ActiveAttr
  describe "ActiveAttr::VERSION" do
    subject { VERSION }

    it { should be_a_kind_of String }

    describe "is compliant with Semantic Versioning <http://semver.org/>" do
      let(:gem_version) { Gem::Version.new VERSION }
      subject { gem_version }

      it { subject.should have_at_least(3).segments }
      it { subject.should have_at_most(5).segments }

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
        subject { VERSION.split(".")[3] }

        it "is nil or starts with a letter and is alphanumeric" do
          (subject.nil? || subject =~ /^[A-Za-z][0-9A-Za-z]*?/).should be_true
        end
      end
    end
  end
end
