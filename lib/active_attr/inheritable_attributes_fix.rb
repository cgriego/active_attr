# Bug of ruby 1.8.7
#
# Code:
#
# class Base
#   def self.inherited(sub)
#     p "Base is being inherited"
#   end
# end

# class A < Base
#   p "Declaring A"
# end

# B = Class.new(Base) do
#   p "Declaring B"
# end
#
# Output:
#
# "Base is being inherited"
# "Declaring A"
# "Declaring B"
# "Base is being inherited"

class Object
  def self.inherited(child)
    if defined?(ClassInheritableAttributes) && !child.instance_variable_defined?('@inheritable_attributes')
      inherited_with_inheritable_attributes(child)
    end
  end
end
