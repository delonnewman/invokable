require_relative 'compose'

module Invokable
  # The core methods that are mixed into classes at a class and instance level when they
  # include {Invokable}.
  #
  # @note This module should not be used directly.
  module Core
    include Compose

    # Return a Proc that forwards it's arguments along to call.
    #
    # @return [Proc]
    def to_proc
      lambda do |*args|
        call(*args)
      end
    end
  
    # Return a curried proc. If the optional arity argument is given, it determines the number of arguments.
    # A curried proc receives some arguments. If a sufficient number of arguments are supplied, it passes the
    # supplied arguments to the original proc and returns the result. Otherwise, returns another curried proc
    # that takes the rest of arguments.
    #
    # @param arity [Integer]
    #
    # @return [Proc]
    def curry(arity = nil)
      if arity
        to_proc.curry(arity)
      else
        to_proc.curry
      end
    end
  
    # Return a memoized proc, that is, a proc that caches it's return values by it's arguments.
    #
    # @return [Proc]
    def memoize
      lambda do |*args|
        @memo ||= {}
        @memo[args.hash] ||= call(*args)
      end
    end

    # Return the arity (i.e. the number of arguments) of the "call" method.
    #
    # @version 0.5.0
    #
    # @return [Integer]
    def arity
      method(:call).arity
    end

    # For Proc compatibility, forwards it's arguments to "call".
    #
    # @version 0.7.0
    def [](*args)
      call(*args)
    end

    # Call invokable with one argument, allows invokables to be used in case statements
    # and Enumerable#grep.
    #
    # @version 0.7.0
    def ===(obj)
      call(obj)
    end
  end
end
