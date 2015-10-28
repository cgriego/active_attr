require "spec_helper"
require "active_attr/typecasting/unknown_typecaster_error"

module ActiveAttr
  module Typecasting
    describe UnknownTypecasterError do
      it { is_expected.to be_a_kind_of TypeError }
      it { is_expected.to be_a_kind_of Error }
    end
  end
end
