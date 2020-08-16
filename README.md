![Ruby](https://github.com/delonnewman/invokable/workflows/Ruby/badge.svg)
[![Gem Version](https://badge.fury.io/rb/invokable.svg)](https://badge.fury.io/rb/invokable)

# Invokable

Objects are functions! Treat any Object or Class as a Proc (like Enumerable but for Procs)

## Synopsis

Hashes can be treated as functions of their keys

```ruby
require 'invokable'
require 'invokable/hash'

number_names = { 1 => "One", 2 => "Two", 3 => "Three" }
[1, 2, 3, 4].map(&number_names) # => ["One", "Two", "Three", nil]
```

Arrays can be treated as functions of their indexes

```ruby
require 'invokable'
require 'invokable/array'

alpha = ('a'..'z').to_a
[1, 2, 3, 4].map(&alpha) # => ["b", "c", "d", "e"]
```

Sets can be treated as predicates

```ruby
require 'invokable'
require 'invokable/set'

favorite_numbers = Set[3, Math::PI]
[1, 2, 3, 4].select(&favorite_numbers) # => [3]
```

Objects that enclose state, can be treated as automatically curried functions.

```ruby
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

Use `memoize`, `<<` and `>>` for composition and other methods on Proc on your command objects

```ruby
# app/queries/filter_records.rb
class FilterRecords
  include Invokable

  def initialize(params)
    @params = params
  end

  def call(params)
    # do filtering return records
  end
end

# app/queries/sort_records.rb
class SortRecords
  include Invokable

  def initialize(params)
    @params = params
  end

  def call(records)
    # do sorting return records
  end
end

sort_and_filter = SortRecords.call(params) << FilterRecords.call(params)
sort_and_filter.call(records) # => sorted and filtered records
```

Helper methods that can be used with any object that responds to `call` or `to_proc`

```ruby
Invokable.juxtapose(:sum, -> (xs) { xs.reduce(:*) }, :min, :max).([3, 4, 6]) # => [13, 72, 3, 6]

Invokable.knit(:upcase, :downcase).(['FoO', 'BaR']) # => ["FOO", "bar"]
```

They are also mixed into any class that includes the module

```ruby
class Transformer
  include Invokable

  def call(array)
    array.map(&juxtapose(identity, compose(:to_s, :upcase))).to_h
  end
end

Transformer.call([:a, :b, :c, :d]) # => {:a => "A", :b => "B", :c => "C", :d => "D"} 
```

Use as much or a little as you need

```ruby
require 'invokable'         # loads Invokable module
require 'invokable/helpers' # loads Invokable::Helpers module
require 'invokable/hash'    # loads hash patch
require 'invokable/array'   # loads array patch
require 'invokable/set'     # loads set patch
require 'invokable/data'    # loads hash, set and array patches
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

## API Documentation

[https://www.rubydoc.info/gems/invokable](https://www.rubydoc.info/gems/invokable)

## See Also

  - [Closures and Objects are Equivalent](http://wiki.c2.com/?ClosuresAndObjectsAreEquivalent)
  - [Clojure](https://clojure.org)
  - [Arc](http://www.arclanguage.org)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
