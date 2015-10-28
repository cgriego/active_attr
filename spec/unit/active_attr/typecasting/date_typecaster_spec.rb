require "spec_helper"
require "active_attr/typecasting/date_typecaster"

module ActiveAttr
  module Typecasting
    describe DateTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original date for a Date" do
          value = Date.today
          expect(typecaster.call(value)).to equal value
        end

        it "returns nil for nil" do
          expect(typecaster.call(nil)).to equal nil
        end

        it "returns nil for an invalid String" do
          expect(typecaster.call("x")).to equal nil
        end

        it "casts a UTC Time to a Date representing the date portion" do
          expect(typecaster.call(Time.utc(2012, 1, 1, 0, 0, 0))).to eql Date.new(2012, 1, 1)
        end

        it "casts a local Time to a Date representing the date portion" do
          expect(typecaster.call(Time.local(2012, 1, 1, 0, 0, 0))).to eql Date.new(2012, 1, 1)
        end

        it "casts a UTC DateTime to a Date representing the date portion" do
          expect(typecaster.call(DateTime.new(2012, 1, 1, 0, 0, 0))).to eql Date.new(2012, 1, 1)
        end

        it "casts an offset DateTime to a Date representing the date portion" do
          expect(typecaster.call(DateTime.new(2012, 1, 1, 0, 0, 0, "-12:00"))).to eql Date.new(2012, 1, 1)
        end

        it "casts an ISO8601 date String to a Date" do
          expect(typecaster.call("2012-01-01")).to eql Date.new(2012, 1, 1)
        end

        it "casts an RFC2616 date and GMT time String to a Date representing the date portion" do
          expect(typecaster.call("Sat, 03 Feb 2001 00:00:00 GMT")).to eql Date.new(2001, 2, 3)
        end

        it "casts an RFC3339 date and offset time String to a Date representing the date portion" do
          expect(typecaster.call("2001-02-03T04:05:06+07:00")).to eql Date.new(2001, 2, 3)
        end

        it "casts a UTC ActiveSupport::TimeWithZone to a Date representing the date portion" do
          expect(typecaster.call(Time.utc(2012, 1, 1, 0, 0, 0).in_time_zone("UTC"))).to eql Date.new(2012, 1, 1)
        end

        it "casts an Alaska ActiveSupport::TimeWithZone to a Date representing the date portion" do
          expect(typecaster.call(Time.utc(2012, 1, 1, 0, 0, 0).in_time_zone("Alaska"))).to eql Date.new(2011, 12, 31)
        end
      end
    end
  end
end
