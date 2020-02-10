require 'invokable/version'

# TODO: Add curry, memoize, transducers?
module Invokable
  # If object responds to `call` convert into a Proc forwards it's arguments along to `call`.
  #
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

  def curry
    to_proc.curry
  end
end
