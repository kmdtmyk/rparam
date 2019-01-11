# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Converter do

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

    end

  end

end
