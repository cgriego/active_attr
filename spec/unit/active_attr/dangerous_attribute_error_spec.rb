require "spec_helper"
require "active_attr/dangerous_attribute_error"

module ActiveAttr
  describe DangerousAttributeError do
    it { is_expected.to be_a_kind_of ScriptError }
    it { is_expected.to be_a_kind_of Error }
  end
end
