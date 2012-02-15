require "spec_helper"
require "active_attr/matchers"

module ActiveAttr
  describe Matchers do
    let(:dsl) { Object.new.extend described_class }
    subject { dsl }

    it { should respond_to(:have_attribute).with(1).argument }

    describe "#have_attribute" do
      subject { dsl.have_attribute(:first_name) }

      it "builds a HaveAttributeMatcher" do
        should be_a_kind_of Matchers::HaveAttributeMatcher
      end

      it "uses the given attribute name to construct the matcher" do
        subject.send(:attribute_name).should == :first_name
      end
    end
  end
end
