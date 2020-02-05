require 'invokable/version'

# TODO: Add curry, memoize, transducers?
module Invokable
  # If object responds to `call` convert into a Proc that takes a key and returns the value of the Hash for that key.
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
end
