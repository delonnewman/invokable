module Invokable
  module Core
    # If object responds to `call` convert into a Proc forwards it's arguments along to `call`.
    #
    # @see https://ruby-doc.org/core-2.7.0/Proc.html#method-i-call Proc#call
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
  
    # Return a curried proc. If the optional `arity` argument is given, it determines the number of arguments.
    # A curried proc receives some arguments. If a sufficient number of arguments are supplied, it passes the
    # supplied arguments to the original proc and returns the result. Otherwise, returns another curried proc
    # that takes the rest of arguments.
    #
    # @see https://ruby-doc.org/core-2.7.0/Proc.html#method-i-curry Proc#curry
    # @param arity [Integer]
    # @return [Proc]
    def curry(arity = nil)
      to_proc.curry(arity)
    end
  
    # Return a memoized proc, that is, a proc that caches it's return values by it's arguments.
    #
    # @return [Proc]
    def memoize
      Proc.new do |*args|
        @memo ||= {}
        @memo[args.hash] ||= call(*args)
      end
    end

    # Return the arity (i.e. the number of arguments) of the `call` method.
    #
    # @version 0.5.0
    # @see https://ruby-doc.org/core-2.7.1/Proc.html#method-i-arity Proc#arity
    # @return [Integer]
    def arity
      method(:call).arity
    end
  end
end
