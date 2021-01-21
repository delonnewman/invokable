# frozen_string_literal: true

require 'invokable/version'
require 'invokable/core'
require 'invokable/helpers'
require 'core_ext'

# A module that attempts to generalize the notion of a first class function or Procs as they are often called
# in Ruby. It enables any class and it's objects to be treated as first-class functions. It also provides helpers
# includes helpers that can be used for performing higher-order operations on and object that can be treated
# as a function.
#
# @example
#   class TwitterPoster
#     include Invokable
#   
#     def initialize(model)
#       @model = model
#     end
#   
#     def call(user)
#       # do the dirt
#       ...
#       TwitterStatus.new(user, data)
#     end
#   end
#   
#   TwitterPoster.call(Model.find(1)) # => #<TwitterPoster ...>
#   TwitterPoster.call(Model.find(1), current_user) # => #<TwitterStatus ...>
module Invokable
  extend Invokable::Helpers

  def self.included(base)
    INCLUDED_MODULES.each do |mod|
      base.include(mod)
      base.extend(mod)
    end
    base.extend(ClassMethods)
  end

  private

  INCLUDED_MODULES = [Core, Helpers].freeze
  private_constant :INCLUDED_MODULES

  # The methods that are mixed into any class at the class level that includes {Invokable}.
  #
  # @note The module should not be used directly.
  module ClassMethods
    # Return the "total" arity of the class (i.e. the arity of the initializer and the arity of the call method)
    #
    # @version 0.6.0
    #
    # @return [Integer]
    def arity
      return initializer_arity + invoker_arity if invoker_arity >= 0

      (initializer_arity + invoker_arity.abs) * -1
    end

    # Handle automatic currying--will accept either the initializer arity or the total arity of the class. If
    # the initializer arity is used return a class instance. If the total arity is used instantiate the class
    # and return the results of the `call` method.
    #
    # @version 0.6.0
    #
    # @see arity
    def call(*args, **kwargs)
      initializer = initializer_arity
      raise ArgumentError, "variable length initializer methods are not supported by Invokable try using `new' or `curry' instead" if initializer < 0
      raise ArgumentError, "block arguments are not supported by Invokable" if block_given?
      
      return new.call if arity.zero?
  
      argc    = kwargs.empty? ? args.length : args.length + 1
      invoker = invoker_arity
      return new(*args).call           if argc == initializer && invoker.zero? && kwargs.empty?
      return new(*args, **kwargs).call if argc == initializer && invoker.zero?
      return new(*args).call           if argc == initializer && invoker == -1 && kwargs.empty?
      return new(*args).call(**kwargs) if argc == initializer && invoker == -1
      return new(*args)                if argc == initializer && kwargs.empty?
      return new(*args, **kwargs)      if argc == initializer

      if argc == arity || invoker_arity < 0 && (args.length - initializer) >= (invoker.abs - 1)
        init_args = args.slice(0, initializer)
        call_args = args.slice(initializer, args.length)
        return new(*init_args).call(*call_args) if kwargs.empty?
        return new(*init_args).call(*call_args, **kwargs)
      else
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{arity})" if initializer == arity
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{initializer} or #{arity})"
      end
    end

    def initializer_arity
      instance_method(:initialize).arity
    end

    def invoker_arity
      instance_method(:call).arity
    end
  end
end
