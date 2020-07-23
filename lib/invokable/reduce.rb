module Invokable
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

  # TODO: make map and select return lazy enumerators
  def map(enumerable)
    array = []
    
    enumerable.each do |x|
      array.push(call(x))
    end

    array
  end

  def select(enumerable)
    array = []

    enumerable.each do |x|
      y = call(x)
      array.push(x) if y
    end

    array
  end
end
