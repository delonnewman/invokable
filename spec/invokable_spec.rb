RSpec.describe Invokable do
  include Gen::Test

  class Add
    include Invokable
    def call(a, b)
      a + b
    end
  end

  class Double
    include Invokable
    def call(x)
      x + x
    end
  end

  class Sq
    include Invokable
    def call(x)
      x * x
    end
  end

  class Arity0
    include Invokable
    def call
      []
    end
  end

  class Arity3
    include Invokable
    def call(a, b, c)
      [a, b, c]
    end
  end

  context 'Hash#to_proc' do
    it "should return a proc that maps a hash's keys to it's values" do
      number_names = { 1 => "One", 2 => "Two", 3 => "Three" }
      number_names.keys.each do |key|
        expect(number_names.to_proc[key]).to eq(number_names[key])
      end
      expect([1, 2, 3, 4].map(&number_names)).to eq(["One", "Two", "Three", nil])
    end
  end

  context 'Array#to_proc' do
    it "should return a proc that maps an array's indexes to it's values" do
      alpha = ('a'..'z').to_a
      for i in (0..alpha.length - 1)
        expect(alpha.to_proc[i]).to eq(alpha[i])
      end
      expect(alpha.to_proc[alpha.length + (0..10).to_a.sample]).to be_nil
      expect([1, 2, 3, 4].map(&alpha)).to eq(%w{b c d e})
    end
  end

  context 'Set#to_proc' do
    it "should return a proc that maps a set's elements to a true or false response of it's inclusion in the set" do
      favorite_numbers = Set[3, Math::PI]
      expect(favorite_numbers.to_proc[1]).to eq(false)
      expect(favorite_numbers.to_proc[3]).to eq(true)
      expect(favorite_numbers.to_proc[Math::PI]).to eq(true)
      expect([1, 2, 3, 4].select(&favorite_numbers)).to eq([3])
    end
  end

  context 'Core#memoize' do
    class SlowServiceObject
      include Invokable

      attr_reader :duration

      def initialize
        @duration = (1..3).to_a.sample
      end

      def call(x)
        sleep duration
        x + 1
      end
    end

    it 'should return a memoized proc' do
      object = SlowServiceObject.new
      memoized = object.memoize
      for_all Integer do |int|
        t0 = Time.now
        y = object.call(int)
        t1 = Time.now
        y_ = memoized.call(int)
        t2 = Time.now
        y__ = memoized.call(int)
        t3 = Time.now
        expect((t1 - t0).round).to eq(object.duration)
        expect((t2 - t1).round).to eq(object.duration)
        expect((t3 - t2).round).to eq(0)
        expect(y).to eq(y_)
        expect(y).to eq(y__)
        expect(object.call(int)).to eq(memoized.call(int))
      end
    end
  end

  context 'Compose' do
    context '<<' do
      it 'should compose to the left' do
        for_all Integer do |int|
          expect((Double.new << Sq.new).call(int)).to eq((int * int) + (int * int))
        end
      end
    end

    context '>>' do
      it 'should compose to the right' do
        for_all Integer do |int|
          expect((Double.new >> Sq.new).call(int)).to eq((int + int) * (int + int))
        end
      end
    end
  end

  context 'Core#arity' do
    it 'should return the arity of the call method' do
      expect(Arity0.new.arity).to eq Arity0.new.call.length
      expect(Arity3.new.arity).to eq Arity3.new.call(1, 2, 3).length
    end
  end

  context 'reduce and friends' do
    it '' do
      expect(Add.new.reduce([1, 2, 3])).to eq 6
    end
  end
end
