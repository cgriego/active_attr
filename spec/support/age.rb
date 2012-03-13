class Age
  def ==(other)
    other.kind_of?(self.class) && other.to_i == to_i
  end

  def initialize(years)
    @years = years.to_i
  end

  def inspect
    "#{@years} years old"
  end

  def to_i
    @years
  end
end
