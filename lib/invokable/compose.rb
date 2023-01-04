module Invokable
  # The {<<} and {>>} methods for right and left function composition.
  # 
  # This module is included in the {Invokable} module and the Proc and Method classes
  # when used with versions of Ruby earlier than 2.6 (when they were added).
  #
  # @note This module should not be used directly.
  module Compose
    # Return a proc that is the composition of this invokable and the given invokable.
    # The returned proc takes a variable number of arguments, calls invokable with
    # them then calls this proc with the result.
    #
    # @param [#call] invokable
    #
    # @return [Proc]
    def <<(invokable)
      lambda do |*args|
        call(Invokable.coerce(invokable).call(*args))
      end
    end

    # Return a proc that is the composition of this invokable and the given invokable.
    # The returned proc takes a variable number of arguments, calls invokable with
    # them then calls this proc with the result.
    #
    # @param [#call] invokable
    #
    # @return [Proc]
    def >>(invokable)
      lambda do |*args|
        Invokable.coerce(invokable).call(call(*args))
      end
    end
  end
end
