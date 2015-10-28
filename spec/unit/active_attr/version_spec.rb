require "spec_helper"
require "active_attr/version"

module ActiveAttr
  describe "ActiveAttr::VERSION" do
    subject { VERSION }

    it { is_expected.to be_a_kind_of String }

    describe "is compliant with Semantic Versioning <http://semver.org/>" do
      let(:gem_version) { Gem::Version.new VERSION }
      subject(:version) { gem_version }

      it { expect(version.segments.size).to be >= 3 }
      it { expect(version.segments.size).to be <= 5 }

      describe "major version" do
        subject { gem_version.segments[0] }

        it { is_expected.to be_a_kind_of Fixnum }
      end

      describe "minor version" do
        subject { gem_version.segments[1] }

        it { is_expected.to be_a_kind_of Fixnum }
      end

      describe "patch version" do
        subject { gem_version.segments[2] }

        it { is_expected.to be_a_kind_of Fixnum }
      end

      describe "pre-release version" do
        subject(:pre_release_version) { VERSION.split(".")[3] }

        it "is nil or starts with a letter and is alphanumeric" do
          expect(pre_release_version.nil? || pre_release_version =~ /^[A-Za-z][0-9A-Za-z]*?/).to eq(true)
        end
      end
    end
  end
end
