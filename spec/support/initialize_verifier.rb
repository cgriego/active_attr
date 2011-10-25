module InitializeVerifier
  def initialize(*args)
    @initialized = true
    super
  end

  def initialized?
    @initialized ||= false
  end
end
