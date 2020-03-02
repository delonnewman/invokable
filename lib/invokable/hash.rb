require_relative 'core'

# Extend core Hash object by aliasing it's `dig` method as `call`,
# and including the `Invokable` module.
#
# @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-dig Hash#dig
class Hash
  if RUBY_VERSION.split('.').take(2).join('.').to_f < 2.7
    include Invokable::Core
    alias call dig
  end
end
