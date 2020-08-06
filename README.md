![Ruby](https://github.com/delonnewman/invokable/workflows/Ruby/badge.svg)
[![Gem Version](https://badge.fury.io/rb/invokable.svg)](https://badge.fury.io/rb/invokable)

# Invokable

Objects are functions! Treat any Object, Hashes, Arrays, and Sets as Procs (like Enumerable but for Procs)

## Synopsis

```ruby
require 'invokable'
require 'invokable/hash'

number_names = { 1 => "One", 2 => "Two", 3 => "Three" }
[1, 2, 3, 4].map(&number_names) # => ["One", "Two", "Three", nil]
```

```ruby
require 'invokable'
require 'invokable/array'

alpha = ('a'..'z').to_a
[1, 2, 3, 4].map(&alpha) # => ["b", "c", "d", "e"]
```

```ruby
require 'invokable'
require 'invokable/set'

favorite_numbers = Set[3, Math::PI]
[1, 2, 3, 4].select(&favorite_numbers) # => [3]
```

```ruby
# service objects
require 'invokable'

class GetDataFromSomeService
  include Invokable

  def call(user)
    # do the dirt
  end
end

data_for_user = GetDataFromSomeService.new.memoize # 'memoize' makes a proc that caches results
User.all.map(&data_for_user)
```
```ruby
# command objects that enclose state, can be treated as automatically curried functions.
require 'invokable'

class TwitterPoster
  include Invokable

  def initialize(model)
    @model = model
  end

  def call(user)
    # do the dirt
    ...
    TwitterStatus.new(user, data)
  end
end

TwitterPoster.call(Model.find(1)) # => #<TwitterPoster ...>
TwitterPoster.call(Model.find(1), current_user) # => #<TwitterStatus ...>

# both the class and it's instances can be used anywhere Procs are.

Model.where(created_at: Date.today).map(&TwitterPoster) # => [#<TwitterPoster ...>, ...]
```

Use as much or a little as you need:

```ruby
require 'invokable'         # loads Invokable module
require 'invokable/hash'    # loads hash patch
require 'invokable/array'   # loads array patch
require 'invokable/set'     # loads set patch
require 'invokable/data'    # loads hash and set patches
```

## Why?

A function is a mapping of one value to another with the additional constraint that for the one input value you will
always get the same output value. So, conceptually, Ruby Hashes, Arrays, and Sets are all functions. Also, there are
many one method objects out there (e.g. Service Objects) that are essentially functions. Why not treat them as such?

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'invokable'
```

And then execute:

    > bundle

Or install it yourself as:

    > gem install invokable

## API

### `to_proc => Proc`

```ruby
hash = { a: 1, b, 2 }
hash.class          # => Hash
hash.to_proc.class  # => Proc
[:a, :b].map(&hash) # => [1, 2]
```

Convert an object into a proc. When the `Invokable` module is included in a class it will do this by
returning a proc that passes it's arguments to the object's `call` method. When `invokable/data` is
loaded `Hash#call` is mapped to `Hash#dig`, `Array#call` is mapped to `Array#at`, and `Set#call`
is mapped to `Set#include?`.

### `curry(arity = nil) => Proc`

Returns a curried proc. If the `arity` is given, it determines the number of arguments.
(see [Proc#curry](https://ruby-doc.org/core-2.7.0/Proc.html#method-i-curry)).

### `memoize => Proc`

Returns a memoized proc, that is, a proc that caches it's return values by it's arguments.

### `<<(invokable) => Proc`

Returns a proc that is a composition of this invokable and the given invokable.

### `>>(invokable) => Proc`

Returns a proc that is a composition of this invokable and the given invokable.

## See Also

  - [Closures and Objects are Equivalent](http://wiki.c2.com/?ClosuresAndObjectsAreEquivalent)
  - [Clojure](https://clojure.org)
  - [Arc](http://www.arclanguage.org)

## TODO

  - benchmark Invokable#to_proc

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
