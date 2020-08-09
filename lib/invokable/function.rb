module Invokable
  class Function
    include Invokable

    def initialize
      freeze
    end
  end
end
