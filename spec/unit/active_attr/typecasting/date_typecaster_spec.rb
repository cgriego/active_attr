require "spec_helper"
require "active_attr/typecasting/date_typecaster"

module ActiveAttr
  module Typecasting
    describe DateTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original date for a Date" do
          value = Date.today
          typecaster.call(value).should equal value
        end

        it "returns nil for nil" do
          typecaster.call(nil).should equal nil
        end

        it "returns nil for an invalid String" do
          typecaster.call("x").should equal nil
        end

        it "casts a UTC Time to a Date representing the date portion" do
          typecaster.call(Time.utc(2012, 1, 1, 0, 0, 0)).should eql Date.new(2012, 1, 1)
        end

        it "casts a local Time to a Date representing the date portion" do
          typecaster.call(Time.local(2012, 1, 1, 0, 0, 0)).should eql Date.new(2012, 1, 1)
        end

        it "casts a UTC DateTime to a Date representing the date portion" do
          typecaster.call(DateTime.new(2012, 1, 1, 0, 0, 0)).should eql Date.new(2012, 1, 1)
        end

        it "casts an offset DateTime to a Date representing the date portion" do
          typecaster.call(DateTime.new(2012, 1, 1, 0, 0, 0, "-12:00")).should eql Date.new(2012, 1, 1)
        end

        it "casts an ISO8601 date String to a Date" do
          typecaster.call("2012-01-01").should eql Date.new(2012, 1, 1)
        end

        it "casts an RFC2616 date and GMT time String to a Date representing the date portion" do
          typecaster.call("Sat, 03 Feb 2001 00:00:00 GMT").should eql Date.new(2001, 2, 3)
        end

        it "casts an RFC3339 date and offset time String to a Date representing the date portion" do
          typecaster.call("2001-02-03T04:05:06+07:00").should eql Date.new(2001, 2, 3)
        end

        it "casts a UTC ActiveSupport::TimeWithZone to a Date representing the date portion" do
          typecaster.call(Time.utc(2012, 1, 1, 0, 0, 0).in_time_zone("UTC")).should eql Date.new(2012, 1, 1)
        end

        it "casts an Alaska ActiveSupport::TimeWithZone to a Date representing the date portion" do
          typecaster.call(Time.utc(2012, 1, 1, 0, 0, 0).in_time_zone("Alaska")).should eql Date.new(2011, 12, 31)
        end
      end
    end
  end
end
