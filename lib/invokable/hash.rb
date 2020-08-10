# Extend core Hash object by adding {to_proc} so hashes can be treated as functions of their keys.
#
# @note {to_proc} was added to Hash in Ruby 2.7 so this patch is only applied for older versions of Ruby.
class Hash
  if RUBY_VERSION.split('.').take(2).join('.').to_f < 2.7
    # Return a proc that takes a key and returns the value associated with it or nil if the key
    # is not present in the hash.
    #
    # @return [Proc]
    def to_proc
      lambda do |key|
        fetch(key) { nil }
      end
    end
  end
end
