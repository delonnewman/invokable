# Change Log

## 0.4.2

- `invokable/array` is no longer loaded with `invokable/data`.
   This created a bit of havok in a few places. Including breaking
   puma bootup in Rails 5.2.4.1.

## 0.5.0

- Added `Invokable::Command` and `Invokable::Core#arity`
