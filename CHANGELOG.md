# Change Log

## 0.7.2

Variable arity invoker methods are handled properly. Variable arity initializers will result in a more meaningful exception being raised.

## 0.7.1

### Invokable::call

When all the arguments of the initializer are passed and the instance method is zero arity the instance method will be called.

```ruby
class Greeter
  def initialize(name)
    @name = name
  end

  def call
    "Hello #{name}"
  end
end

Greeter.call("Jane") # => "Hello Jane"
Greeter.call("John") # => #<Greeter ...> (before 0.7.1)
```

## 0.7.0

- Added helper methods `juxtapose`, `knit`, `compose`, `identity`, `always`, `guarded`, `partial`, and `coerce`
  that can be used as module functions on `Invokable` or in classes that mixin the `Invokable` module.

- For classes whose initialize method takes no arguments, when the class method `call` is called it will
  initialize the class and call it's `call` method.

- `[]` and `===` are added to classed that mixin `Invokable` for better `Proc` compatibility.

- `Array`, `Hash` and `Set` patches no longer include the invokable methods, they simply add `to_proc`.

- When `invokable/data` is required the array patch is also loaded.

- All the methods that take an invokable will "coerce" the invokable by simply returning it if it implements `call`
  or coercing it into a proc if it implements `to_proc`.

## 0.6.0

- `Invokable::Closure` deprecated comparable behavior has been added to `Invokable` itself.

## 0.5.2

- `Invokable::Command` deprecated in favor of `Invokable::Closure`.

## 0.5.0

- Added `Invokable::Command` and `Invokable::Core#arity`

## 0.4.2

- `invokable/array` is no longer loaded with `invokable/data`.
   This created a bit of havok in a few places. Including breaking
   puma bootup in Rails 5.2.4.1.
