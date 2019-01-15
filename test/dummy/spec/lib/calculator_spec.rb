# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Calculator do
  include ActiveSupport::Testing::TimeHelpers

  describe 'add' do

    describe 'inclusion' do

      example do
        calculator = Rparam::Calculator.new({ order: 'asc' })
        calculator.add :order, inclusion: %w(asc desc)
        expect(calculator.result[:order]).to eq 'asc'

        calculator = Rparam::Calculator.new({ order: 'foo' })
        calculator.add :order, inclusion: %w(asc desc)
        expect(calculator.result[:order]).to eq nil
      end

      example 'with default value' do
        calculator = Rparam::Calculator.new({ order: 'asc' })
        calculator.add :order, inclusion: %w(asc desc), default: 'asc'
        expect(calculator.result[:order]).to eq 'asc'

        calculator = Rparam::Calculator.new({ order: 'foo' })
        calculator.add :order, inclusion: %w(asc desc), default: 'asc'
        expect(calculator.result[:order]).to eq 'asc'
      end

    end

    describe 'exclusion' do

      example do
        calculator = Rparam::Calculator.new({ value: 'a' })
        calculator.add :value, exclusion: 'a'
        expect(calculator.result[:value]).to eq nil

        calculator = Rparam::Calculator.new({ value: 'a' })
        calculator.add :value, exclusion: %w(a b c)
        expect(calculator.result[:value]).to eq nil

        calculator = Rparam::Calculator.new({ value: 'd' })
        calculator.add :value, exclusion: %w(a b c)
        expect(calculator.result[:value]).to eq 'd'
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

    end

    describe 'type: Date' do

      example 'date' do
        calculator = Rparam::Calculator.new({ value: '2018-05-15' })
        calculator.add :value, type: Date
        expect(calculator.result[:value]).to eq Date.new(2018, 5, 15)
      end

      example 'month' do
        calculator = Rparam::Calculator.new({ value: '2018-05' })
        calculator.add :value, type: Date
        expect(calculator.result[:value]).to eq Date.new(2018, 5, 1)

        calculator = Rparam::Calculator.new({ value: '2018-5' })
        calculator.add :value, type: Date
        expect(calculator.result[:value]).to eq Date.new(2018, 5, 1)
      end

      example 'year' do
        calculator = Rparam::Calculator.new({ value: '2018' })
        calculator.add :value, type: Date
        expect(calculator.result[:value]).to eq Date.new(2018, 1, 1)
      end

      example 'invalid date' do
        calculator = Rparam::Calculator.new({ value: 'invalid' })
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
        expect(calculator.result[:value]).to eq nil
      end

      example 'without parameter' do
        calculator = Rparam::Calculator.new
        calculator.add :value, type: Array
        expect(calculator.result[:value]).to eq nil
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

    describe 'save' do

      example 'true' do
        calculator = Rparam::Calculator.new({ order: 'asc' })
        calculator.add :order, save: true
        expect(calculator.result[:order]).to eq 'asc'
        expect(calculator.memory[:order]).to eq 'asc'
      end

      example 'with memory' do
        calculator = Rparam::Calculator.new({}, { order: 'asc' })
        calculator.add :order, save: true
        expect(calculator.result[:order]).to eq 'asc'
        expect(calculator.memory[:order]).to eq 'asc'
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

        example do
          travel_to Date.new(2018, 10, 15)
          calculator = Rparam::Calculator.new({ value: '2018-10-20' })
          calculator.add :value, save: :relative_date
          expect(calculator.result[:value]).to eq '2018-10-20'
          expect(calculator.memory[:value]).to eq 5
        end

        example 'blank' do
          calculator = Rparam::Calculator.new({ value: '' })
          calculator.add :value, save: :relative_date
          expect(calculator.result[:value]).to eq ''
          expect(calculator.memory[:value]).to eq nil
        end

        example 'without params' do
          calculator = Rparam::Calculator.new
          calculator.add :value, save: :relative_date
          expect(calculator.result[:value]).to eq nil
          expect(calculator.memory.has_key? :value).to eq false
        end

        example 'with default value' do
          today = Date.today
          calculator = Rparam::Calculator.new
          calculator.add :value, type: Date, save: :relative_date, default: today
          expect(calculator.result[:value]).to eq today
        end

        describe 'with memory' do

          example 'valid value' do
            travel_to Date.new(2018, 10, 15)
            calculator = Rparam::Calculator.new({}, { value: 5 })
            calculator.add :value, save: :relative_date
            expect(calculator.result[:value]).to eq '2018-10-20'
            expect(calculator.memory[:value]).to eq 5
          end

          example 'valid value with default' do
            travel_to Date.new(2018, 10, 15)
            calculator = Rparam::Calculator.new({}, { value: 5 })
            calculator.add :value, save: :relative_date, default: Date.today
            expect(calculator.result[:value]).to eq '2018-10-20'
            expect(calculator.memory[:value]).to eq 5
          end

          example 'invalid value' do
            calculator = Rparam::Calculator.new({}, { value: 'invalid' })
            calculator.add :value, save: :relative_date
            expect(calculator.result[:value]).to eq nil

            calculator = Rparam::Calculator.new({}, { value: '' })
            calculator.add :value, save: :relative_date
            expect(calculator.result[:value]).to eq nil

            calculator = Rparam::Calculator.new({}, { value: nil })
            calculator.add :value, save: :relative_date
            expect(calculator.result[:value]).to eq nil
          end

          example 'invalid value with default' do
            travel_to Date.new(2018, 10, 15)
            calculator = Rparam::Calculator.new({}, { value: nil })
            calculator.add :value, save: :relative_date, default: Date.today
            expect(calculator.result[:value]).to eq '2018-10-15'
          end

        end

      end

    end

  end

end
