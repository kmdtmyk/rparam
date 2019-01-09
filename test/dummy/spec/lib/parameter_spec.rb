# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Parameter do

  describe 'config' do

    let(:parameter){ Rparam::Parameter.new }
    subject{ parameter.config }

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

  end

end
