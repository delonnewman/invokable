require_relative '../invokable'

# Extend core Hash object by aliasing it's `dig` method as `call`,
# and including the `Invokable` module.
#
# @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-dig Hash#dig
class Hash
  include Invokable
  alias call dig
end
