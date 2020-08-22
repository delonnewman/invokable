module Invokable
  # A collection of helper methods for working with invokables where they accept and invokable
  # as an argument they will "coerce" the value (see {coerce}). This enables any method that
  # implements `call` or `to_proc` to be treated as an invokable.
  #
  # @version 0.7.0
  module Helpers
    # Return a proc that returns the value that is passed to it.
    #
    # @version 0.7.0
    #
    # @return [Proc]
    def identity
      lambda do |x|
        x
      end
    end
  
    # Return a proc that will always return the value given it.
    #
    # @version 0.7.0
    #
    # @return [Proc]
    def always(x)
      lambda do
        x
      end
    end
  
    # If the invokable passed responds to :call it will be returned. If it responds to to_proc to_proc
    # is called and the resulting proc is returned. Otherwise a TypeError will be raised.
    #
    # @version 0.7.0
    def coerce(invokable)
      return invokable         if invokable.respond_to?(:call)
      return invokable.to_proc if invokable.respond_to?(:to_proc)
  
      raise TypeError, "#{invokable.inspect} is not a valid invokable"
    end
  
    # Return a proc that passes it's arguments to the given invokables and returns an array of results.
    # The invokables passed will be coerced before they are called (see {coerce}).
    #
    # @version 0.7.0
    #
    # @example
    #   juxtapose(:first, :count).call('A'..'Z') # => ["A", 26]
    #
    # @return [Proc]
    def juxtapose(*invokables)
      lambda do |*args|
        invokables.map do |invokable|
          coerce(invokable).call(*args)
        end
      end
    end
    alias juxt juxtapose
  
    # A relative of {juxtapose}--return a proc that takes a collection and calls the invokables
    # on their corresponding values (in sequence) in the collection. The invokables passed
    # will be coerced before they are called (see {coerce}).
    #
    # @version 0.7.0
    #
    # @example
    #   knit(:upcase, :downcase).call(['FoO', 'BaR']) # => ["FOO", "bar"]
    # 
    # @return [Proc]
    def knit(*invokables)
      lambda do |enumerable|
        results = []
        enumerable.each_with_index do |x, i|
          return results if invokables[i].nil?
  
          results << coerce(invokables[i]).call(x)
        end
        results
      end
    end
    
    # Return a proc that is a composition of the given invokables from right-to-left. The invokables
    # passed will be coerced before they are called (see {coerce}).
    #
    # @version 0.7.0
    #
    # @example
    #   compose(:to_s, :upcase).call(:this_is_a_test) # => "THIS_IS_A_TEST"
    #
    # @return [Proc]
    def compose(*invokables)
      return identity              if invokables.empty?
      return coerce(invokables[0]) if invokables.count == 1
  
      if invokables.count == 2
        f, g = invokables
        return lambda do |*args|
          coerce(f).call(coerce(g).call(*args))
        end
      end
  
      invokables.reduce do |a, b|
        compose(a, b)
      end
    end
  
    # Return a proc that guards it's arguments from nil by replacing nil values with the alternative
    # value that corresponds to it's place in the argument list. The invokable passed will be coerced
    # before they are called (see {coerce}).
    #
    # @version 0.7.0
    #
    # @example
    #   count = guarded(:count, [])
    #   count.call(nil) # => 0
    #   count.call([1]) # => 1
    #
    # @return [Proc]
    def guarded(invokable, *alternatives)
      lambda do |*args|
        new_args = args.each_with_index.map do |x, i|
          x.nil? ? alternatives[i] : x
        end
        coerce(invokable).call(*new_args)
      end
    end
    alias fnil guarded
    alias nil_safe guarded
  
    # Given an invokable and and a fewer number of arguments that the invokable takes return
    # a proc that will accept the rest of the arguments (i.e. a partialy applied function).
    # 
    # @version 0.7.0
    #
    # @return [Proc]
    def partial(invokable, *args)
      lambda do |*other_args|
        coerce(invokable).call(*(args + other_args))
      end
    end
  end
end
