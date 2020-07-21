module Invokable
  # Treat "Command Objects" as curried functions
  #
  # @see https://ruby-doc.org/core-2.7.0/Proc.html#method-i-curry Proc#curry
  #
  # @version 0.5.0
  module Command
    def self.included(klass)
      klass.include(Invokable)
      klass.extend(Invokable::Core)
      klass.extend(Invokable::Compose)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      # Return the "total" arity of the class (i.e. the arity of the initializer and the arity of the call method)
      #
      # @version 0.5.0
      # @see https://ruby-doc.org/core-2.7.1/Proc.html#method-i-arity Proc#arity
      # @see initializer_arity
      #
      # @return [Integer]
      def arity
        initializer_arity + instance_method(:call).arity
      end
  
      # Return the arity of the initializer
      #
      # @version 0.5.0
      # @see arity
      #
      # @return [Integer]
      def initializer_arity
        @initializer ? @initializer.arity : 0
      end
  
      # To specify any enclosed state
      def enclose(&block)
        raise 'A block is required' if block.nil?
  
        @initializer = block
        define_method :initialize, &block
      end
  
      # Handle automatic currying--will accept either the initializer arity or the total arity of the class. If
      # the initializer arity is used return a class instance. If the total arity is used instantiate the class
      # and return the results of the `call` method.
      #
      # @version 0.5.0
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
          raise "Wrong number of arguments expected #{initializer_arity} or #{arity}, got: #{args.length}"
        end
      end
    end
  end
end
