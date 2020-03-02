require_relative 'core'

# Extend core Array object by aliasing it's `[]` method as `call`,
# and including the `Invokable` module.
#
# @see https://ruby-doc.org/core-2.7.0/Array.html#method-i-5B-5D Array#[]
class Array
  include Invokable::Core
  alias call []
end
