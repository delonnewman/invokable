require 'invokable/version'
require 'invokable/core'
require 'invokable/compose'

# TODO: make use of Gem::Version
if RUBY_VERSION.split('.').take(2).join('.').to_f < 2.6
  require 'invokable/proc'
  require 'invokable/method'
end

module Invokable
  def self.included(base)
    base.include(Invokable::Core)
    base.include(Invokable::Compose)
    base.extend(Invokable::Core)
    base.extend(Invokable::Compose)
    base.extend(ClassMethods)
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
      if args.length == initializer_arity
        new(*args)
      elsif args.length == arity
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
