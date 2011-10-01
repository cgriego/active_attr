module ActiveAttr
  module MassAssignment
    def assign_attributes(new_attributes, options={})
      new_attributes.each do |name, value|
        writer = "#{name}="
        send writer, value if respond_to? writer
      end if new_attributes
    end

    def attributes=(new_attributes)
      assign_attributes new_attributes
    end

    def initialize(attributes=nil, options={})
      assign_attributes attributes, options
    end
  end
end
