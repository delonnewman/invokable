module Invokable
  module Reduceable
    # TODO: for zero arity return a transducer
    def reduce(enumerable, memo = nil)
      if memo.nil?
        memo       = enumerable.first
        enumerable = enumerable.drop(1)
      end
  
      enumerable.each do |x|
        memo = call(memo, x)
      end
  
      memo
    end
    alias :foldr :reduce
  
    def map(sequence)
      Enumerator::Lazy.new(sequence) do |yielder, value|
        result = call(value)
        yielder << result
      end
    end
    alias :collect :map
  
    def filter_map(sequence)
      Enumerator::Lazy.new(sequence) do |yielder, value|
        result = call(*values)
        yielder << result if result
      end
    end
  
    def select(sequence)
      Enumerator::Lazy.new(sequence) do |yielder, value|
        result = call(value)
        yielder << value if result
      end
    end
    alias :filter :select
  
    def reject(sequence)
      Enumerator::Lazy.new(sequence) do |yielder, value|
        result = call(value)
        yielder << value unless result
      end
    end
  end
end

class Gt
  include Invokable
  def initialize(x)
    @x = x
  end

  def call(y)
    @x < y
  end
end