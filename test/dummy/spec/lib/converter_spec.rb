# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Converter do
  include ActiveSupport::Testing::TimeHelpers

  describe 'add' do

    describe 'inclusion' do

      example do
        converter = Rparam::Converter.new({ order: 'asc' })
        converter.add :order, inclusion: %w(asc desc)
        expect(converter.diff[:order]).to eq 'asc'

        converter = Rparam::Converter.new({ order: 'foo' })
        converter.add :order, inclusion: %w(asc desc)
        expect(converter.diff[:order]).to eq nil
      end

      example 'with default value' do
        converter = Rparam::Converter.new({ order: 'asc' })
        converter.add :order, inclusion: %w(asc desc), default: 'asc'
        expect(converter.diff[:order]).to eq 'asc'

        converter = Rparam::Converter.new({ order: 'foo' })
        converter.add :order, inclusion: %w(asc desc), default: 'asc'
        expect(converter.diff[:order]).to eq 'asc'
      end

    end

    describe 'exclusion' do

      example do
        converter = Rparam::Converter.new({ value: 'a' })
        converter.add :value, exclusion: 'a'
        expect(converter.diff[:value]).to eq nil

        converter = Rparam::Converter.new({ value: 'a' })
        converter.add :value, exclusion: %w(a b c)
        expect(converter.diff[:value]).to eq nil

        converter = Rparam::Converter.new({ value: 'd' })
        converter.add :value, exclusion: %w(a b c)
        expect(converter.diff[:value]).to eq 'd'
      end

    end

    describe 'type: Date' do

      example 'date' do
        converter = Rparam::Converter.new({ value: '2018-05-15' })
        converter.add :value, type: Date
        expect(converter.diff[:value]).to eq Date.new(2018, 5, 15)
      end

      example 'month' do
        converter = Rparam::Converter.new({ value: '2018-05' })
        converter.add :value, type: Date
        expect(converter.diff[:value]).to eq Date.new(2018, 5, 1)

        converter = Rparam::Converter.new({ value: '2018-5' })
        converter.add :value, type: Date
        expect(converter.diff[:value]).to eq Date.new(2018, 5, 1)
      end

      example 'year' do
        converter = Rparam::Converter.new({ value: '2018' })
        converter.add :value, type: Date
        expect(converter.diff[:value]).to eq Date.new(2018, 1, 1)
      end

      example 'invalid date' do
        converter = Rparam::Converter.new({ value: 'invalid' })
        converter.add :value, type: Date
        expect(converter.diff[:value]).to eq nil
      end

      example 'with default value' do
        today = Date.today
        converter = Rparam::Converter.new
        converter.add :value, type: Date, default: today
        expect(converter.diff[:value]).to eq today

        converter = Rparam::Converter.new
        converter.add :value, type: Date, default: 7.days.ago
        expect(converter.diff[:value]).to eq today - 7

        converter = Rparam::Converter.new({ value: '' })
        converter.add :value, type: Date, default: today
        expect(converter.diff[:value]).to eq nil
      end

    end

    describe 'type: Array' do

      example 'array' do
        converter = Rparam::Converter.new({ value: %w(a b c) })
        converter.add :value, type: Array
        expect(converter.diff[:value]).to eq %w(a b c)
      end

      example 'not array' do
        converter = Rparam::Converter.new({ value: 'invalid' })
        converter.add :value, type: Array
        expect(converter.diff[:value]).to eq []
      end

      example 'without parameter' do
        converter = Rparam::Converter.new
        converter.add :value, type: Array
        expect(converter.diff[:value]).to eq []
      end

      example 'with inclusion' do
        converter = Rparam::Converter.new({ value: %w(a b c) })
        converter.add :value, type: Array, inclusion: 'a'
        expect(converter.diff[:value]).to eq %w(a)

        converter = Rparam::Converter.new({ value: %w(a b c) })
        converter.add :value, type: Array, inclusion: %w(b c d)
        expect(converter.diff[:value]).to eq %w(b c)
      end

      example 'with exclusion' do
        converter = Rparam::Converter.new({ value: %w(a b c) })
        converter.add :value, type: Array, exclusion: 'a'
        expect(converter.diff[:value]).to eq %w(b c)

        converter = Rparam::Converter.new({ value: %w(a b c) })
        converter.add :value, type: Array, exclusion: %w(b c d)
        expect(converter.diff[:value]).to eq %w(a)

        converter = Rparam::Converter.new({ value: ['', '1'] })
        converter.add :value, type: Array, exclusion: ''
        expect(converter.diff[:value]).to eq %w(1)
      end

      example 'with default value' do
        converter = Rparam::Converter.new
        converter.add :value, type: Array, default: %w(a b c)
        expect(converter.diff[:value]).to eq %w(a b c)
      end

      example 'save' do
        converter = Rparam::Converter.new({ value: %w(a b c) })
        converter.add :value, type: Array, save: true
        expect(converter.diff[:value]).to eq %w(a b c)
        expect(converter.memory[:value]).to eq %w(a b c)
      end

      example 'save with memory' do
        converter = Rparam::Converter.new({}, { value: %w(a b c) })
        converter.add :value, type: Array, save: true
        expect(converter.diff[:value]).to eq %w(a b c)
        expect(converter.memory[:value]).to eq %w(a b c)
      end

    end

    describe 'save' do

      example 'true' do
        converter = Rparam::Converter.new({ order: 'asc' })
        converter.add :order, save: true
        expect(converter.diff[:order]).to eq 'asc'
        expect(converter.memory[:order]).to eq 'asc'
      end

      example 'with memory' do
        converter = Rparam::Converter.new({}, { order: 'asc' })
        converter.add :order, save: true
        expect(converter.diff[:order]).to eq 'asc'
        expect(converter.memory[:order]).to eq 'asc'
      end

      example 'false' do
        converter = Rparam::Converter.new({ order: 'asc' })
        converter.add :order, save: false
        expect(converter.diff[:order]).to eq 'asc'
        expect(converter.memory.has_key? :order).to eq false

        converter = Rparam::Converter.new({})
        converter.add :order, save: false
        expect(converter.diff[:order]).to eq nil
        expect(converter.memory.has_key? :order).to eq false
      end

      describe 'relative date' do

        example do
          travel_to Date.new(2018, 10, 15)
          converter = Rparam::Converter.new({ value: '2018-10-20' })
          converter.add :value, save: :relative_date
          expect(converter.diff[:value]).to eq '2018-10-20'
          expect(converter.memory[:value]).to eq 5
        end

        example 'blank' do
          converter = Rparam::Converter.new({ value: '' })
          converter.add :value, save: :relative_date
          expect(converter.diff[:value]).to eq ''
          expect(converter.memory[:value]).to eq nil
        end

        example 'without params' do
          converter = Rparam::Converter.new
          converter.add :value, save: :relative_date
          expect(converter.diff[:value]).to eq ''
          expect(converter.memory.has_key? :value).to eq false
        end

        example 'with default value' do
          today = Date.today
          converter = Rparam::Converter.new
          converter.add :value, type: Date, save: :relative_date, default: today
          expect(converter.diff[:value]).to eq today
        end

        describe 'with memory' do

          example 'valid value' do
            travel_to Date.new(2018, 10, 15)
            converter = Rparam::Converter.new({}, { value: 5 })
            converter.add :value, save: :relative_date
            expect(converter.diff[:value]).to eq '2018-10-20'
            expect(converter.memory[:value]).to eq 5
          end

          example 'invalid value' do
            converter = Rparam::Converter.new({}, { value: 'invalid' })
            converter.add :value, save: :relative_date
            expect(converter.diff[:value]).to eq ''

            converter = Rparam::Converter.new({}, { value: '' })
            converter.add :value, save: :relative_date
            expect(converter.diff[:value]).to eq ''

            converter = Rparam::Converter.new({}, { value: nil })
            converter.add :value, save: :relative_date
            expect(converter.diff[:value]).to eq ''
          end

          example 'invalid value with default value' do
            travel_to Date.new(2018, 10, 15)
            converter = Rparam::Converter.new({}, { value: nil })
            converter.add :value, save: :relative_date, default: Date.today
            expect(converter.diff[:value]).to eq '2018-10-15'
          end

        end

      end

    end

  end

end
