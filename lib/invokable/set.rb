require 'set'

# Extend stdlib Set object by adding {to_proc} which will allow a set to be treated as a function of
# the membership of it's elements.
class Set
  # Return a proc that takes an value and return true if the value is an element of the set, but returns
  # false otherwise.
  #
  # @return [Proc]
  def to_proc
    lambda do |element|
      include?(element)
    end
  end
end
