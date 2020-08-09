class Proc
  def &(invokable)
    lambda do |*args|
      [self.call(*args), Invokable.coerce(invokable).call(*args)].flatten
    end
  end

  def apply(array)
    call(*array)
  end
end
