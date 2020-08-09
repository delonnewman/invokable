module Invokable
  module Compose
    # Return a proc that is the composition of this invokable and the given `invokable`.
    # The returned proc takes a variable number of arguments, calls `invokable` with
    # them then calls this proc with the result.
    #
    # @return [Proc]
    def <<(invokable)
      lambda do |*args|
        call(Invokable.coerce(invokable).call(*args))
      end
    end

    # Return a proc that is the composition of this invokable and the given `invokable`.
    # The returned proc takes a variable number of arguments, calls `invokable` with
    # them then calls this proc with the result.
    #
    # @return [Proc]
    def >>(invokable)
      lambda do |*args|
        Invokable.coerce(invokable).call(call(*args))
      end
    end
  end
end
