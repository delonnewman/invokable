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
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{initializer_arity} or #{arity})"
        end
      end

      # Specify any enclosed state with a block or named attributes
      # 
      # @example
      #   class TwitterPater
      #     include Invokable::Command
      #
      #     enclose :api_key
      #
      #     def call(user)
      #       # interact with twitter, return results
      #     end
      #   end
      #
      #   TwitterPater.new(API_KEY).call(User.find(1))
      #   TwitterPater.new(API_KEY).api_key == API_KEY # => true
      #
      #   class TwitterPater
      #     include Invokable::Command
      #
      #     enclose do |api_key|
      #       @api_key = api_key
      #     end
      #
      #     def call(user)
      #       # interact with twitter, return results
      #     end
      #   end
      #
      #   TwitterPater.new(API_KEY).call(User.find(1))
      #   TwitterPater.new(API_KEY).api_key # error 'method' missing
      def enclose(*names, &block)
        define_initializer_with_block(block) unless block.nil?

        define_initializer_with_names(names)
      end
  
      private

      def define_initializer_with_block(block)
        @initializer = block
        define_method :initialize, &block
      end

      def define_initializer_with_names(names)
        @initializer_arity = names.length

        names.each do |name|
          attr_reader name
        end

        define_method :initialize do |*args|
          names.each_with_index do |name, i|
            instance_variable_set(:"@#{name}", args[i])
          end
        end
      end
    end
  end
end
