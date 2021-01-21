RSpec.describe Invokable do
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
      (0..alpha.length - 1).each do |i|
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

  context 'Compose' do
    class Add
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

    context '<<' do
      it 'should compose to the left' do
        int = (1..100).to_a.sample
        
        expect((Add.new << Sq.new).call(int)).to eq((int * int) + (int * int))
      end
    end

    context '>>' do
      it 'should compose to the right' do
        int = (1..100).to_a.sample

        expect((Add.new >> Sq.new).call(int)).to eq((int + int) * (int + int))
      end
    end
  end

  context 'Core#arity' do
    class Arity
      include Invokable
      def call(a, b, c); end
    end

    it 'should return the arity of the call method' do
      expect(Arity.new.arity).to eq 3
    end
  end

  context 'classes as curried functions' do
    class PersonBuilder
      include Invokable
  
      def initialize(department)
        @department = department
      end
  
      def call(name, dob)
        { name: name, dob: dob, department: @department }
      end
    end
  
    it 'should automatically curry' do
      dept   = :it
      name   = 'Dave Smith'
      dob    = Date.new(1973, 9, 10)
  
      person = PersonBuilder.call(dept, name, dob)
      expect(person[:name]).to eq name
      expect(person[:dob]).to eq dob
      expect(person[:department]).to eq dept
  
      it_worker_builder = PersonBuilder.call(dept)
      expect(it_worker_builder).to be_instance_of PersonBuilder
  
      person = it_worker_builder.call(name, dob)
      expect(person[:name]).to eq name
      expect(person[:dob]).to eq dob
      expect(person[:department]).to eq dept
    end

    it 'should be invokable' do
      departments = [:it, :hr, :accounting]
      expect(departments.map(&PersonBuilder).map(&:department)).to eq departments
    end

    context 'zero arity' do
      class One
        include Invokable

        def call
          1
        end
      end

      class AnotherOne
        include Invokable

        def initialize(one)
          @one = one
        end

        def call
          @one
        end
      end

      class Identity
        include Invokable

        def call(x)
          x
        end
      end

      it 'should call the instance method if the all the arguments for the initializer are given and the instance method is arity zero' do
        expect(AnotherOne.call(1)).to eq 1
      end

      it 'should call the instance method if the initializer is arity zero' do
        expect(One.call).to eq 1
        expect(Identity.call(3)).to eq 3
      end
    end

    context 'variable arity' do
      class AddOrInc
        include Invokable

        def initialize(x)
          @x = x
        end

        def call(y = 1)
          @x + y
        end
      end

      class Maybe3D
        include Invokable

        def initialize(x)
          @x = x
        end

        def call(y, z = nil)
          return [@x, y, z] if z

          [@x, y]
        end
      end

      class ThreeD
        include Invokable

        def call(y, x = 0, z = 0)
          [y, x, z]
        end
      end

      it 'should calculate the correct arity' do
        expect(AddOrInc.arity).to eq -2
        expect(AddOrInc.initializer_arity).to eq 1
        expect(AddOrInc.invoker_arity).to eq -1
      end

      it 'should pass along variable arguments if the invoker method is variable arity' do
        expect(AddOrInc.call(3)).to eq 4
        expect(AddOrInc.call(5, 4)).to eq 9
      end

      it 'should handle non -1 variable arity methods' do
        expect(Maybe3D.call(1, 2, 3)).to eq [1, 2, 3]
        expect(Maybe3D.call(1, 2)).to eq [1, 2]

        expect(ThreeD.call(1, 2, 3)).to eq [1, 2, 3]
        expect(ThreeD.call(1, 2)).to eq [1, 2, 0]
        expect(ThreeD.call(1)).to eq [1, 0, 0]
      end
    end
  
    context '.arity' do
      it 'should return the arity of the initializer and the call method' do
        expect(PersonBuilder.arity).to eq 3
      end
    end
  
    context '#arity' do
      it 'should return the arity of the call method' do
        expect(PersonBuilder.call(:it).arity).to eq 2
      end
    end
  end

  context 'keyword arguments' do
    class ArgForwarder
      include Invokable

      def call(*args)
        args
      end
    end

    class OptionForwarder
      include Invokable

      def call(one, **options)
        [one, options]
      end
    end

    class LastInitializer
      include Invokable

      def initialize(one, two, test:)
        @one = one
        @two = two
        @test = test
      end

      def call(three)
        { one: @one, two: @two, test: @test, three: three }
      end
    end

    class LastArgument
      include Invokable

      def initialize(one, two)
        @one = one
        @two = two
      end

      def call(three:)
        { one: @one, two: @two, three: three }
      end
    end

    it 'should pass the keyword arguments along' do
      result = ArgForwarder.call(1, 2, 3, a: 1, b: 2, c: 3)
      expect(result).to eq [1, 2, 3, { a: 1, b: 2, c: 3 }]

      first, options = OptionForwarder.call(1, a: 1, b: 2, c: 3)
      expect(first).to be 1
      expect(options).to eq({ a: 1, b: 2, c: 3 })

      curried = LastInitializer.call(1, 2, test: :testing)
      expect(LastInitializer.arity).to be 4
      expect(LastInitializer.initializer_arity).to be 3
      expect(LastInitializer.invoker_arity).to be 1
      expect(curried.call(4)).to eq({ one: 1, two: 2, test: :testing, three: 4 })

      result = LastArgument.call(1, 2, three: :testing)
      expect(result).to eq({ one: 1, two: 2, three: :testing })
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
      object   = SlowServiceObject.new
      memoized = object.memoize
      int      = (1..10).to_a.sample

      t0  = Time.now
      y   = object.call(int)
      t1  = Time.now
      y_  = memoized.call(int)
      t2  = Time.now
      y__ = memoized.call(int)
      t3  = Time.now

      expect((t1 - t0).round).to eq(object.duration)
      expect((t2 - t1).round).to eq(object.duration)
      expect((t3 - t2).round).to eq(0)
      expect(y).to eq(y_)
      expect(y).to eq(y__)
      expect(object.call(int)).to eq(memoized.call(int))
    end
  end
end
