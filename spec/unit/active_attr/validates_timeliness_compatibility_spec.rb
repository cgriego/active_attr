require "spec_helper"
require "active_attr/attribute_defaults"
require "validates_timeliness"
require "date"

module ActiveAttr
  describe "compatibility_with_validates_timeliness" do
    before(:each) do
      class TestTimelinessClass
        include ActiveAttr::Model
        include ValidatesTimeliness
        attribute :first_name
        attribute :last_name
        attribute :age, :default => nil
        attribute :created_at
        validates_time :created_at
      end
    end

    context "An ActiveAttr class with validates_timeliness installed" do
      subject { TestTimelinessClass.new }

      it "accepts validates_time as a validator" do
        expect do
          class TestTimelinessClass
            include ActiveModel::Validations
            validates_time :created_at
          end
        end.should_not raise_exception
      end

      it "accepts validates_date as a validator" do
        expect do
          class TestTimelinessClass
            include ActiveModel::Validations
            validates_date :created_at
          end
        end.should_not raise_exception
      end

      context "with a time validator in place" do

        it "rejects entries missing the validated field" do
          test_object = TestTimelinessClass.new
          test_object.should_not be_valid
        end

        it "accepts entries that are times" do
          test_object = TestTimelinessClass.new
          test_object.created_at = Time.at(100)
          test_object.should be_valid
        end

        it "causes non-time entries to fail validation" do
          test_object = TestTimelinessClass.new
          test_object.created_at = "Foo"
          test_object.should_not be_valid
        end
      end

      context "with a date validator in place" do
        before(:each) do
          class TestDateClass
            include ActiveAttr::Model
            include ValidatesTimeliness
            attribute :birthday
            validates_date :birthday
          end
        end

        
        it "rejects entries missing the validated field" do
          test_object = TestDateClass.new
          test_object.should_not be_valid
        end

        it "accepts entries that are times" do
          test_object = TestDateClass.new
          test_object.birthday = Date.today
          test_object.should be_valid
        end

        it "causes non-time entries to fail validation" do
          test_object = TestDateClass.new
          test_object.birthday = "Foo"
          test_object.should_not be_valid
        end
    
      end

    end
  end
end
