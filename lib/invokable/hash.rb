require_relative '../invokable'

class Hash
  include Invokable
  alias call []
end
