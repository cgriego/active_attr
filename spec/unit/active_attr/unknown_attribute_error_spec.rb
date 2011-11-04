require "spec_helper"
require "active_attr/unknown_attribute_error"

module ActiveAttr
  describe UnknownAttributeError do
    it { should be_a_kind_of NoMethodError }
    it { should be_a_kind_of Error }
  end
end
