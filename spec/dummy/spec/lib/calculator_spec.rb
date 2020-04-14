# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Calculator do
  include ActiveSupport::Testing::TimeHelpers

  describe 'add' do

    describe 'inclusion' do

      example do
        expect(Rparam::Transformer).to receive(:inclusion).with(1, 2).and_return(3)

        calculator = Rparam::Calculator.new({ value: 1 })
        calculator.add :value, inclusion: 2
        expect(calculator.result[:value]).to eq 3
      end

      example 'with default value' do
        calculator = Rparam::Calculator.new({ order: 'asc' })
        calculator.add :order, inclusion: %w(asc desc), default: 'asc'
        expect(calculator.result[:order]).to eq 'asc'

        calculator = Rparam::Calculator.new({ order: 'foo' })
        calculator.add :order, inclusion: %w(asc desc), default: 'asc'
        expect(calculator.result[:order]).to eq 'asc'
      end

      example 'with default value (lambda)' do
        calculator = Rparam::Calculator.new
        calculator.add :value, default: -> { 1 }
        expect(calculator.result[:value]).to eq 1
      end

    end

    describe 'exclusion' do

      example do
        expect(Rparam::Transformer).to receive(:exclusion).with(1, 2).and_return(3)

        calculator = Rparam::Calculator.new({ value: 1 })
        calculator.add :value, exclusion: 2
        expect(calculator.result[:value]).to eq 3
      end

    end

    describe 'type: Integer' do

      example do
        calculator = Rparam::Calculator.new({ value: '1' })
        calculator.add :value, type: Integer
        expect(calculator.result[:value]).to eq 1
      end

      example 'invalid value' do
        calculator = Rparam::Calculator.new({ value: 'invalid' })
        calculator.add :value, type: Integer
        expect(calculator.result[:value]).to eq nil
      end

      example 'without params' do
        calculator = Rparam::Calculator.new
        calculator.add :value, type: Integer
        expect(calculator.result[:value]).to eq nil
      end

      example 'min' do
        expect(Rparam::Transformer).to receive(:clamp).with(1, 2, nil).and_return(3)

        calculator = Rparam::Calculator.new({ value: 1 })
        calculator.add :value, type: Integer, min: 2
        expect(calculator.result[:value]).to eq 3
      end

      example 'max' do
        expect(Rparam::Transformer).to receive(:clamp).with(1, nil, 2).and_return(3)

        calculator = Rparam::Calculator.new({ value: 1 })
        calculator.add :value, type: Integer, max: 2
        expect(calculator.result[:value]).to eq 3
      end

      example 'min and max' do
        expect(Rparam::Transformer).to receive(:clamp).with(1, 2, 3).and_return(4)

        calculator = Rparam::Calculator.new({ value: 1 })
        calculator.add :value, type: Integer, min: 2, max: 3
        expect(calculator.result[:value]).to eq 4
      end

    end

    describe 'type: Boolean' do

      example do
        calculator = Rparam::Calculator.new({ value: '1' })
        calculator.add :value, type: :boolean
        expect(calculator.result[:value]).to eq true
      end

      example 'default value' do
        calculator = Rparam::Calculator.new
        calculator.add :value, type: :boolean, default: false
        expect(calculator.result[:value]).to eq false
      end

    end

    describe 'type: Date' do

      example 'date' do
        date = Date.new(2018, 5, 15)
        expect(Rparam::Parser).to receive(:parse_date).with('2018-05-15').and_return(date)

        calculator = Rparam::Calculator.new({ value: '2018-05-15' })
        calculator.add :value, type: Date
        expect(calculator.result[:value]).to eq date
      end

      example 'nil' do
        date = Date.new(2018, 5, 15)
        expect(Rparam::Parser).to receive(:parse_date).with('2018-05-15').and_return(nil)

        calculator = Rparam::Calculator.new({ value: '2018-05-15' })
        calculator.add :value, type: Date
        expect(calculator.result[:value]).to eq nil
      end

      example 'with default value' do
        today = Date.today
        calculator = Rparam::Calculator.new
        calculator.add :value, type: Date, default: today
        expect(calculator.result[:value]).to eq today

        calculator = Rparam::Calculator.new
        calculator.add :value, type: Date, default: 7.days.ago
        expect(calculator.result[:value]).to eq today - 7

        calculator = Rparam::Calculator.new({ value: '' })
        calculator.add :value, type: Date, default: today
        expect(calculator.result[:value]).to eq nil
      end

      example 'with invalid default value' do
        calculator = Rparam::Calculator.new
        calculator.add :value, type: Date, default: nil
        expect(calculator.result[:value]).to eq nil

        calculator = Rparam::Calculator.new
        calculator.add :value, type: Date, default: 'invalid'
        expect(calculator.result[:value]).to eq nil
      end

    end

    describe 'type: Array' do

      example 'array' do
        calculator = Rparam::Calculator.new({ value: %w(a b c) })
        calculator.add :value, type: Array
        expect(calculator.result[:value]).to eq %w(a b c)
      end

      example 'not array' do
        calculator = Rparam::Calculator.new({ value: 'invalid' })
        calculator.add :value, type: Array
        expect(calculator.result[:value]).to eq []
      end

      example 'without parameter' do
        calculator = Rparam::Calculator.new
        calculator.add :value, type: Array
        expect(calculator.result[:value]).to eq []
      end

      example 'with inclusion' do
        calculator = Rparam::Calculator.new({ value: %w(a b c) })
        calculator.add :value, type: Array, inclusion: 'a'
        expect(calculator.result[:value]).to eq %w(a)

        calculator = Rparam::Calculator.new({ value: %w(a b c) })
        calculator.add :value, type: Array, inclusion: %w(b c d)
        expect(calculator.result[:value]).to eq %w(b c)
      end

      example 'with exclusion' do
        calculator = Rparam::Calculator.new({ value: %w(a b c) })
        calculator.add :value, type: Array, exclusion: 'a'
        expect(calculator.result[:value]).to eq %w(b c)

        calculator = Rparam::Calculator.new({ value: %w(a b c) })
        calculator.add :value, type: Array, exclusion: %w(b c d)
        expect(calculator.result[:value]).to eq %w(a)

        calculator = Rparam::Calculator.new({ value: ['', '1'] })
        calculator.add :value, type: Array, exclusion: ''
        expect(calculator.result[:value]).to eq %w(1)
      end

      example 'with default value' do
        calculator = Rparam::Calculator.new
        calculator.add :value, type: Array, default: %w(a b c)
        expect(calculator.result[:value]).to eq %w(a b c)

        calculator = Rparam::Calculator.new({ value: 'invalid' })
        calculator.add :value, type: Array, default: []
        expect(calculator.result[:value]).to eq []

        calculator = Rparam::Calculator.new
        calculator.add :value, type: Array, default: []
        expect(calculator.result[:value]).to eq []
      end

      example 'save' do
        calculator = Rparam::Calculator.new({ value: %w(a b c) })
        calculator.add :value, type: Array, save: true
        expect(calculator.result[:value]).to eq %w(a b c)
        expect(calculator.memory[:value]).to eq %w(a b c)
      end

      example 'save with memory' do
        calculator = Rparam::Calculator.new({}, { value: %w(a b c) })
        calculator.add :value, type: Array, save: true
        expect(calculator.result[:value]).to eq %w(a b c)
        expect(calculator.memory[:value]).to eq %w(a b c)
      end

    end

    describe 'type: nested parameter' do

      example 'integer' do
        calculator = Rparam::Calculator.new({ item: { value: '1500' } })
        calculator.add :item, type: { value: { type: Integer } }
        expect(calculator.result[:item]).to eq({ value: 1500 })
      end

      example 'date' do
        calculator = Rparam::Calculator.new({ item: { value: '2019-05-15' } })
        calculator.add :item, type: { value: { type: Date } }
        expect(calculator.result[:item]).to eq({ value: Date.new(2019, 5, 15) })
      end

      example 'multiple parameter' do
        calculator = Rparam::Calculator.new({ item: { value1: '1500', value2: '2019-05-15' } })
        calculator.add :item, type: { value1: { type: Integer }, value2: { type: Date } }
        expect(calculator.result[:item]).to eq({ value1: 1500, value2: Date.new(2019, 5, 15) })
      end

    end

    describe 'save' do

      example 'true' do
        calculator = Rparam::Calculator.new({ order: 'asc' })
        calculator.add :order, save: true
        expect(calculator.result[:order]).to eq 'asc'
        expect(calculator.memory[:order]).to eq 'asc'
      end

      example 'type Date' do
        calculator = Rparam::Calculator.new({ value: '2019-05-15' })
        calculator.add :value, save: true, type: Date
        expect(calculator.result[:value]).to eq Date.new(2019, 5, 15)
        expect(calculator.memory[:value]).to eq '2019-05-15'
      end

      example 'type Boolean' do
        calculator = Rparam::Calculator.new({ value: '1' })
        calculator.add :value, save: true, type: :boolean
        expect(calculator.result[:value]).to eq true
        expect(calculator.memory[:value]).to eq '1'
      end

      example 'nested parameter' do
        calculator = Rparam::Calculator.new({ item: { value: '1' } })
        calculator.add :item, type: { value: { save: true, type: Integer } }
        expect(calculator.result[:item]).to eq({ value: 1 })
        expect(calculator.memory[:item]).to eq({ value: '1' })
      end

      example 'with memory' do
        calculator = Rparam::Calculator.new({}, { order: 'asc' })
        calculator.add :order, save: true
        expect(calculator.result[:order]).to eq 'asc'
        expect(calculator.memory[:order]).to eq 'asc'
      end

      example 'nested parameter with memory' do
        calculator = Rparam::Calculator.new({}, { item: { value: '1' } })
        calculator.add :item, type: { value: { save: true, type: Integer } }
        expect(calculator.result[:item]).to eq({ value: 1 })
        expect(calculator.memory[:item]).to eq({ value: '1' })
      end

      example 'ignore invalid memory' do
        calculator = Rparam::Calculator.new({}, 123)
        expect{ calculator.add(:value, save: true) }.not_to raise_error
      end

      example 'false' do
        calculator = Rparam::Calculator.new({ order: 'asc' })
        calculator.add :order, save: false
        expect(calculator.result[:order]).to eq 'asc'
        expect(calculator.memory.has_key? :order).to eq false

        calculator = Rparam::Calculator.new({})
        calculator.add :order, save: false
        expect(calculator.result[:order]).to eq nil
        expect(calculator.memory.has_key? :order).to eq false
      end

      describe 'relative date' do

        example 'memory receive write' do
          calculator = Rparam::Calculator.new({ value: '2018-10-20'  })
          memory = calculator.instance_variable_get(:@memory)
          expect(memory).to_not receive(:read).with(:value, :relative_date)
          expect(memory).to receive(:write).with(:value, '2018-10-20', :relative_date)
          calculator.add :value, save: :relative_date
          expect(calculator.result[:value]).to eq '2018-10-20'
        end

        example 'memory receive read' do
          calculator = Rparam::Calculator.new
          memory = calculator.instance_variable_get(:@memory)
          expect(memory).to receive(:read).with(:value, :relative_date).and_return('foo')
          expect(memory).to_not receive(:write).with(:value, nil, :relative_date)
          calculator.add :value, save: :relative_date
          expect(calculator.result[:value]).to eq 'foo'
        end

        example 'with default value' do
          travel_to Date.new(2018, 10, 15)
          calculator = Rparam::Calculator.new
          calculator.add :value, save: :relative_date, default: Date.today
          expect(calculator.result[:value]).to eq '2018-10-15'
        end

        example 'with default value and type Date' do
          today = Date.today
          calculator = Rparam::Calculator.new
          calculator.add :value, type: Date, save: :relative_date, default: today
          expect(calculator.result[:value]).to eq today
        end

      end

      describe 'relative month' do

        example 'memory receive write' do
          calculator = Rparam::Calculator.new({ value: '2018-10'  })
          memory = calculator.instance_variable_get(:@memory)
          expect(memory).to_not receive(:read).with(:value, :relative_month)
          expect(memory).to receive(:write).with(:value, '2018-10', :relative_month)
          calculator.add :value, save: :relative_month
          expect(calculator.result[:value]).to eq '2018-10'
        end

        example 'memory receive read' do
          calculator = Rparam::Calculator.new
          memory = calculator.instance_variable_get(:@memory)
          expect(memory).to receive(:read).with(:value, :relative_month).and_return('foo')
          expect(memory).to_not receive(:write).with(:value, nil, :relative_month)
          calculator.add :value, save: :relative_month
          expect(calculator.result[:value]).to eq 'foo'
        end

        example 'with default value' do
          travel_to Date.new(2018, 10, 15)
          calculator = Rparam::Calculator.new
          calculator.add :value, save: :relative_month, default: Date.today
          expect(calculator.result[:value]).to eq '2018-10'
        end

        example 'with default value and type Date' do
          travel_to Date.new(2018, 10, 15)
          calculator = Rparam::Calculator.new
          calculator.add :value, type: Date, save: :relative_month, default: Date.today
          expect(calculator.result[:value]).to eq Date.new(2018, 10, 1)
        end

      end

      describe 'relative year' do

        example 'memory receive write' do
          calculator = Rparam::Calculator.new({ value: '2018'  })
          memory = calculator.instance_variable_get(:@memory)
          expect(memory).to_not receive(:read).with(:value, :relative_year)
          expect(memory).to receive(:write).with(:value, '2018', :relative_year)
          calculator.add :value, save: :relative_year
          expect(calculator.result[:value]).to eq '2018'
        end

        example 'memory receive read' do
          calculator = Rparam::Calculator.new
          memory = calculator.instance_variable_get(:@memory)
          expect(memory).to receive(:read).with(:value, :relative_year).and_return('foo')
          expect(memory).to_not receive(:write).with(:value, nil, :relative_year)
          calculator.add :value, save: :relative_year
          expect(calculator.result[:value]).to eq 'foo'
        end

        example 'with default value' do
          travel_to Date.new(2018, 10, 15)
          calculator = Rparam::Calculator.new
          calculator.add :value, save: :relative_year, default: Date.today
          expect(calculator.result[:value]).to eq '2018'
        end

        example 'with default value and type Integer' do
          travel_to Date.new(2018, 10, 15)
          calculator = Rparam::Calculator.new
          calculator.add :value, type: Integer, save: :relative_year, default: Date.today
          expect(calculator.result[:value]).to eq 2018
        end

        example 'with default value and type Date' do
          travel_to Date.new(2018, 10, 15)
          calculator = Rparam::Calculator.new
          calculator.add :value, type: Date, save: :relative_year, default: Date.today
          expect(calculator.result[:value]).to eq Date.new(2018, 1, 1)
        end

      end

    end

  end

end
