module ActiveAttr
  class MultiAttr
    class MissingParameter < Exception; end

    attr_accessor :hash
    delegate :[], :has_key?, :to => :hash

    def initialize(hash)
      self.hash = hash
    end

    def to_time
      # If Date bits were not provided, error
      raise MissingParameter if [1,2,3].any?{|position| !has_key?(position)}
      # If Date bits were provided but blank, then return nil
      return nil if (1..3).any? {|position| hash[position].blank?}

      set_values = (1..max_position).collect{|position| hash[position] }
      # If Time bits are not there, then default to 0
      (3..5).each {|i| set_values[i] = set_values[i].blank? ? 0 : set_values[i]}
      instantiate_time_object(set_values)
    end

    def to_date
      return nil if (1..3).any? {|position| hash[position].blank?}
      set_values = [hash[1], hash[2], hash[3]]
      begin
        Date.new(*set_values)
      rescue ArgumentError # if Date.new raises an exception on an invalid date
        instantiate_time_object(set_values).to_date # we instantiate Time object and convert it back to a date thus using Time's logic in handling invalid dates
      end
    end

    def max_position(upper_cap = 100)
      [hash.keys.max, upper_cap].min
    end

    private

    def instantiate_time_object(values)
      if Time.respond_to?(:zone) && Time.zone
        Time.zone.local(*values)
      else
        Time.local(*values)
      end
    end
  end
end
