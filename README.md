![Ruby](https://github.com/delonnewman/invokable/workflows/Ruby/badge.svg)
[![Gem Version](https://badge.fury.io/rb/invokable.svg)](https://badge.fury.io/rb/invokable)

# Invokable

Treat any Object, Hashes, Arrays, and Sets as Procs (like Enumerable but for Procs)

# Synopsis

```ruby
  require 'invokable/hash'

  number_names = { 1 => "One", 2 => "Two", 3 => "Three" }
  [1, 2, 3, 4].map(&number_names) # => ["One", "Two", "Three", nil]
```

```ruby
  require 'invokable/array'

  alpha = ('a'..'z').to_a
  [1, 2, 3, 4].map(&alpha) # => ["b", "c", "d", "e"]
```

```ruby
  require 'invokable/set'

  favorite_numbers = Set[3, Math::PI]
  [1, 2, 3, 4].select(&favorite_numbers) # => [3]
```

```ruby
  require 'invokable'

  # service objects
  class GetDataFromSomeService
    include Invokable

    def call(user)
      # do the dirt
    end
  end

  data_for_user = GetDataFromSomeService.new
  User.all.map(&data_for_user)
```

Use as much or a little as you need:

```ruby
require 'invokable'       # loads Invokable module
require 'invokable/hash'  # loads hash patch
require 'invokable/array' # loads array patch
require 'invokable/set'   # loads set patch
require 'invokable/data'  # loads all patches
```

# Why?

A function is a mapping of one value to another with the additional constraint that for the one input value you will
always get the same output value. So, conceptually, Ruby Hashes, Arrays, and Sets are all functions. Also, there are
many one method objects out thre (e.g. ServiceObjects) that are essentially functions. Why not treat them as such?

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'invokable'
```

And then execute:

    > bundle

Or install it yourself as:

    > gem install invokable

# See Also

  - [Clojure](https://clojure.org)
  - [Arc](http://www.arclanguage.org)

# TODO

  - add support for `curry`, `memoize` and maybe transducers.

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
