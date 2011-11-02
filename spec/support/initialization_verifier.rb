module InitializationVerifier
  def initialize
    @initialized = true
  end

  def initialized?
    @initialized ||= false
  end
end
