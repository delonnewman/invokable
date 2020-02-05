class Array
  # Convert Array into a Proc that takes an index and returns the value of the Array at that index.
  #
  # @return [Proc]
  def to_proc
    lambda do |i, *_|
      self.at(i)
    end
  end
end
