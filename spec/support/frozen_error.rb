# Returns the appropriate frozen error class for the current Ruby version.
# FrozenError was introduced in Ruby 2.5; older Rubies raise RuntimeError.
def frozen_error_class
  defined?(FrozenError) ? FrozenError : RuntimeError
end
