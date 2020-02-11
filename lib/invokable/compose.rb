module Invokable
  module Compose
    # Return a proc that is the composition of this proc and the given `invokable`.
    # The returned proc takes a variable number of arguments, calls `invokable` with
    # them then calls this proc with the result.
    #
    # @return [Proc]
    def <<(invokable)
      Proc.new do |*args|
        call(invokable.call(*args))
      end
    end

    # Return a proc that is the composition of this proc and the given `invokable`.
    # The returned proc takes a variable number of arguments, calls `invokable` with
    # them then calls this proc with the result.
    #
    # @return [Proc]
    def >>(invokable)
      Proc.new do |*args|
        invokable.call(call(*args))
      end
    end
  end
end
