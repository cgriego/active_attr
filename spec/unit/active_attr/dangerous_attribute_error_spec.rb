require "spec_helper"
require "active_attr/dangerous_attribute_error"

module ActiveAttr
  describe DangerousAttributeError do
    it { should be_a_kind_of ScriptError }
    it { should be_a_kind_of Error }
  end
end
