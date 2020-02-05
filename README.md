# Data::Functions

Treat Hashes, Arrays, Sets and Objects as Functions

# Synopsis

```ruby
  require 'data/functions/hash'

  number_names = { 1 => "One", 2 => "Two", 3 => "Three" }
  [1, 2, 3, 4].map(&number_names) # => ["One", "Two", "Three", nil]
```

```ruby
  require 'data/functions/array'

  alpha = ('a'..'z').to_a
  [1, 2, 3, 4].map(&alpha) # => ["b", "c", "d", "e"]
```

```ruby
  require 'data/functions/set'

  favorite_numbers = Set[3, Math::PI]
  [1, 2, 3, 4].select(&favorite_numbers) # => [3]
```

```ruby
  require 'data/functions/object'

  # service objects
  class GetDataFromSomeService
    def call(user)
      # do the dirt
    end
  end

  data_for_user = GetDataFromSomeService.new
  User.all.map(&data_for_user)
```

```ruby
require 'data/functions/hash' # loads hash patch
require 'data/functions/array' # loads array patch
require 'data/functions/set' # loads set patch
require 'data/functions/object' # loads object patch
require 'data/functions' # loads all patches
```

# Why?

A function is a mapping of one value to another with the additional constraint that for the one input value you will
always get the same output value. So, conceptually, Ruby Hashes, Arrays, Sets, and Objects (when treated immutably)
are all functions. Why not treat them as such?

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'data-functions'
```

And then execute:

    > bundle

Or install it yourself as:

    > gem install data-functions

# See Also

  - [Clojure](https://clojure.org)
  - [Arc](http://www.arclanguage.org)

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
