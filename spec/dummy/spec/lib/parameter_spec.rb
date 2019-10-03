# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Parameter do

  describe 'param' do

    let(:parameter){ Rparam::Parameter.new }
    subject{ parameter.to_h }

    it do
      parameter.param :date, type: Date
      expect(subject).to eq({ date: { type: Date } })
    end

    it do
      parameter.param :from_date, type: Date
      parameter.param :to_date, type: Date
      expect(subject).to eq({ from_date: { type: Date }, to_date: { type: Date } })
    end

    it do
      parameter.param :order, inclusion: %w(asc desc)
      parameter.param :order, default: 'asc'
      expect(subject).to eq({ order: { inclusion: %w(asc desc), default: 'asc' } })
    end

    it do
      parameter.param nil, default: 'value'
      expect(subject).to eq({})
    end

    it 'nested parameter' do
      parameter.param :book do
        param :price, type: Integer
        param :release_date, type: Date
      end

      expect(subject).to eq({
        book: {
          type: {
            price: { type: Integer },
            release_date: { type: Date },
          }
        }
      })
    end

  end

end
