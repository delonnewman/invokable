class Set
  # Convert Set into a Proc that takes a value and returns true if the value is an element of the set or false otherwise.
  #
  # @return [Proc]
  def to_proc
    lambda do |v, *_|
      self.include?(v)
    end
  end
end
