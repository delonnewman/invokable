if RUBY_VERSION.split('.').take(2).join('.').to_f < 2.6
  # Add {<<} and {>>} for right and left function composition.
  #
  # @note These methods were added to Ruby in version 2.6 so this patch will only be applied when running older versions.
  class Proc
    include Invokable::Compose
  end

  # Add {<<} and {>>} for right and left function composition.
  #
  # @note These methods were added to Ruby in version 2.6 so this patch will only be applied when running older versions.
  class Method
    include Invokable::Compose
  end
end

class Proc
  include Invokable::Reduceable
end

class Method
  include Invokable::Reduceable
end
