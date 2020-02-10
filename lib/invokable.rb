require 'invokable/version'

# TODO: Add memoize, transducers?
module Invokable
  # If object responds to `call` convert into a Proc forwards it's arguments along to `call`.
  #
  # @see [Proc#call]
  # @return [Proc]
  def to_proc
    if respond_to?(:call)
      # TODO: Would method(:call) be more performant? We need benchmarks.
      Proc.new do |*args|
        call(*args)
      end
    else
      raise "Don't know how to convert #{self.inspect} into a Proc"
    end
  end

  # Return a curried proc. If the optional arity argument is given, it determines the number of arguments.
  # A curried proc receives some arguments. If a sufficient number of arguments are supplied, it passes the
  # supplied arguments to the original proc and returns the result. Otherwise, returns another curried proc
  # that takes the rest of arguments.
  #
  # @see [Proc#curry]
  # @return [Proc]
  def curry(*args)
    to_proc.curry(*args)
  end
end
