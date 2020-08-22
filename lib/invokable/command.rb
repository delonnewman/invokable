require_relative 'closure'

module Invokable
  # Treat "Command Objects" as curried functions
  #
  # @version 0.5.0
  #
  # @deprecated These features are included in the {Invokable} module by default now.
  module Command
    def self.included(klass)
      klass.include(Invokable)
      klass.extend(Invokable::Core)
      klass.extend(Invokable::Compose)
      klass.extend(Invokable::Closure::ClassMethods)
    end
  end
end
