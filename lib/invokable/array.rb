# Extend core Array by adding `to_proc` which will enable arrays to be treated as functions
# of their indexes.
class Array
  # Return a proc that takes the index of the array and returns the value at that index or nil
  # if there is no value at the given index.
  #
  # @return [Proc]
  def to_proc
    lambda do |index|
      at(index)
    end
  end
end
