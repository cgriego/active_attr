require "spec_helper"
require "active_attr/typecasting/date_time_typecaster"

module ActiveAttr
  module Typecasting
    describe DateTimeTypecaster do
      describe "#call" do
        it "returns the original DateTime for a DateTime" do
          value = DateTime.now
          subject.call(value).should equal value
        end

        it "returns nil for nil" do
          subject.call(nil).should equal nil
        end

        it "casts a Date to a DateTime at the beginning of the day with no offset" do
          result = subject.call(Date.new(2012, 1, 1))
          result.should eql DateTime.new(2012, 1, 1)
          result.should be_instance_of DateTime
        end

        it "casts a UTC Time to a DateTime with no offset" do
          result = subject.call(Time.utc(2012, 1, 1, 12, 0, 0))
          result.should eql DateTime.new(2012, 1, 1, 12, 0, 0, 0)
          result.should be_instance_of DateTime
        end

        it "casts a local Time to a DateTime with a matching offset" do
          value = Time.local(2012, 1, 1, 12, 0, 0)
          result = subject.call(value)
          result.should eql DateTime.new(2012, 1, 1, 12, 0, 0, Rational(value.utc_offset, 86400))
          result.should be_instance_of DateTime
        end

        it "casts an ISO8601 date String to a Date" do
          result = subject.call("2012-01-01")
          result.should eql DateTime.new(2012, 1, 1)
          result.should be_instance_of DateTime
        end

        it "casts an RFC2616 date and GMT time String to a DateTime" do
          result = subject.call("Sat, 03 Feb 2001 00:00:00 GMT")
          result.should eql DateTime.new(2001, 2, 3)
          result.should be_instance_of DateTime
        end

        it "casts an RFC3339 date and offset time String to a DateTime" do
          result = subject.call("2001-02-03T04:05:06+07:00")
          result.should eql DateTime.new(2001, 2, 3, 4, 5, 6, "+07:00")
          result.should be_instance_of DateTime
        end

        it "casts a UTC ActiveSupport::TimeWithZone to a DateTime" do
          result = subject.call(Time.utc(2012, 1, 1, 1, 1, 1).in_time_zone("UTC"))
          result.should eql DateTime.new(2012, 1, 1, 1, 1, 1, 0)
          result.should be_instance_of DateTime
        end

        it "casts an Alaska ActiveSupport::TimeWithZone to a Date representing the date portion" do
          result = subject.call(Time.utc(2012, 1, 1, 0, 0, 0).in_time_zone("Alaska"))
          result.should eql DateTime.new(2011, 12, 31, 15, 0, 0, "-09:00")
          result.should be_instance_of DateTime
        end
      end
    end
  end
end
