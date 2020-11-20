require 'date'

require 'invokable'
require 'invokable/closure'
require 'invokable/command'

RSpec.describe Invokable::Closure do
  class PersonBuilder
    include [Invokable::Closure, Invokable::Command].sample

    enclose :department

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

    departments = [:it, :hr, :accounting]
    expect(departments.map(&PersonBuilder).map(&:department)).to eq departments
  end

  context '.enclose' do
    class Block
      include [Invokable::Closure, Invokable::Command].sample

      attr_reader :test

      def initialize(test)
        @test = test
      end
    end

    it 'should initilize state in instances when passed a block' do
      expect(Block.new(1).test).to eq 1
    end
  end

  context '.arity' do
    it 'should return the arity of the initializer and the call method' do
      expect(PersonBuilder.arity).to eq 3
    end
  end

  context '.initializer_arity' do
    it 'should return the arity of the initializer' do
      expect(PersonBuilder.initializer_arity).to eq 1
    end
  end

  context '#arity' do
    it 'should return the arity of the call method' do
      expect(PersonBuilder.call(:it).arity).to eq 2
    end
  end
end
