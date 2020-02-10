require 'set'
require_relative '../invokable'

# Extend stdlib Set object by aliasing it's `include?` method as `call`,
# and including the `Invokable` module.
#
# @see https://ruby-doc.org/stdlib-2.7.0/libdoc/set/rdoc/Set.html#method-i-include-3F Set#include?
class Set
  include Invokable
  alias call include?
end
