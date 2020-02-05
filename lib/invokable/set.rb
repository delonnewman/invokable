require 'set'
require_relative '../invokable'

class Set
  include Invokable
  alias call include?
end
