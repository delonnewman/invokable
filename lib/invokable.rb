require 'invokable/version'
require 'invokable/core'
require 'invokable/compose'
require 'core_ext'

module Invokable
  DEFAULT_MODULES = [
    Invokable::Core,
    Invokable::Compose
  ].freeze

  def self.included(base)
    DEFAULT_MODULES.each do |mod|
      base.include(mod)
      base.extend(mod)
    end
    base.extend(ClassMethods)
  end

  # Return a proc that returns the value that is passed to it.
  #
  # @return [Proc]
  def self.identity
    lambda do |x|
      x
    end
  end

  # Return a proc that will always return the value given it.
  #
  # @return [Proc]
  def self.constantly(x)
    lambda do
      x
    end
  end

  # If the invokable passed responds to :call it will be returned. If
  # it responds to :to_proc :to_proc is called and the resulting proc
  # is returned. Otherwise a TypeError will be thrown.
  def self.coerce(invokable)
    return invokable         if invokable.respond_to?(:call)
    return invokable.to_proc if invokable.respond_to?(:to_proc)

    raise TypeError, "#{invokable.inspect} is not a valid invokable"
  end

  # Return a proc that passes it's arguments to the given invokables and returns an array of results.
  # The invokables passed will be coerced before they are called (see {coerce}).
  #
  # @example
  #   juxtapose(:first, :count).call('A'..'Z') # => ["A", 26]
  #
  # @return [Proc]
  def self.juxtapose(*invokables)
    lambda do |*args|
      invokables.map do |invokable|
        coerce(invokable).call(*args)
      end
    end
  end

  # A relative of {juxtapose}--return a proc that takes a collection and calls the invokables
  # on their corresponding values (in sequence) in the collection. The invokables passed
  # will be coerced before they are called (see {coerce}).
  #
  # @example
  #   knit(:upcase, :downcase).call(['FoO', 'BaR']) # => ["FOO", "bar"]
  # 
  # @return [Proc]
  def self.knit(*invokables)
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
  # @example
  #   compose(:to_s, :upcase).call(:this_is_a_test) # => "THIS_IS_A_TEST"
  #
  # @return [Proc]
  def self.compose(*invokables)
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

  def self.nil_safe(invokable, *alternatives)
    lambda do |*args|
      new_args = args.each_with_index.map do |x, i|
        x.nil? ? alternatives[i] : x
      end
      coerce(invokable).call(*new_args)
    end
  end

  def self.partial(invokable, *args)
    lambda do |*other_args|
      coerce(invokable).call(*(args + other_args))
    end
  end

  module ClassMethods
    # Return the "total" arity of the class (i.e. the arity of the initializer and the arity of the call method)
    #
    # @version 0.6.0
    # @see https://ruby-doc.org/core-2.7.1/Proc.html#method-i-arity Proc#arity
    # @see initializer_arity
    #
    # @return [Integer]
    def arity
      initializer_arity + instance_method(:call).arity
    end

    # Handle automatic currying--will accept either the initializer arity or the total arity of the class. If
    # the initializer arity is used return a class instance. If the total arity is used instantiate the class
    # and return the results of the `call` method.
    #
    # @version 0.6.0
    # @see arity
    # @see initializer_arity
    def call(*args)
      return new.call   if arity == 0
      return new(*args) if args.length == initializer_arity

      if args.length == arity
        init_args = args.slice(0, initializer_arity)
        call_args = args.slice(initializer_arity, args.length)
        new(*init_args).call(*call_args)
      else
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{initializer_arity} or #{arity})"
      end
    end

    private

    def initializer_arity
      instance_method(:initialize).arity
    end
  end
end
