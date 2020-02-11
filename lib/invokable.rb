require 'invokable/version'
require 'invokable/core'
require 'invokable/compose'

if RUBY_VERSION.split('.').take(2).join('.').to_f < 2.6
  require 'invokable/proc'
  require 'invokable/method'
end

module Invokable
  def self.included(base)
    base.include(Invokable::Core)
    base.include(Invokable::Compose)
  end
end
