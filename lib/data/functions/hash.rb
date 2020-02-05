class Hash
  # Convert Hash into a Proc that takes a key and returns the value of the Hash for that key.
  #
  # @return [Proc]
  def to_proc
    lambda do |k, *_|
      self.fetch(k, nil)
    end
  end
end
