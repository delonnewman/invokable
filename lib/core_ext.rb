if RUBY_VERSION.split('.').take(2).join('.').to_f < 2.6
  class Proc
    include Invokable::Compose
  end

  class Method
    include Invokable::Compose
  end
end
