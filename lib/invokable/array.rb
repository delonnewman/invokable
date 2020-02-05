require_relative '../invokable'

class Array
  include Invokable
  alias call at
end
