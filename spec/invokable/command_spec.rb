require 'invokable'
require 'invokable/command'

RSpec.describe Invokable::Command do
  class PersonBuilder
    include Invokable::Command

    attr_reader :department

    enclose do |department|
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

    departments = [:it, :hr, :accounting]
    expect(departments.map(&PersonBuilder).map(&:department)).to eq departments
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