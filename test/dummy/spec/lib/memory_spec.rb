# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Memory do
  include ActiveSupport::Testing::TimeHelpers

  describe 'read' do

    example 'without type' do
      memory = Rparam::Memory.new({ value: 'foo' })
      expect(memory.read :value).to eq 'foo'
    end

    example 'relative date' do
      travel_to Date.new(2018, 10, 15)
      memory = Rparam::Memory.new({ value: 5 })
      expect(memory.read :value, :relative_date).to eq '2018-10-20'
    end

    example 'relative month' do
      travel_to Date.new(2018, 10, 15)
      memory = Rparam::Memory.new({ value: 2 })
      expect(memory.read :value, :relative_month).to eq '2018-12'
    end

    example 'relative year' do
      travel_to Date.new(2018, 10, 15)
      memory = Rparam::Memory.new({ value: 2 })
      expect(memory.read :value, :relative_year).to eq '2020'
    end

    example 'empty' do
      memory = Rparam::Memory.new
      expect(memory.read :value).to eq nil
      expect(memory.read :value, :relative_date).to eq nil
      expect(memory.read :value, :relative_month).to eq nil
      expect(memory.read :value, :relative_year).to eq nil
    end

    example 'invalid type' do
      memory = Rparam::Memory.new
      expect(memory.read :value, :invalid).to eq nil
    end

  end

  describe 'write' do

    let(:memory){ Rparam::Memory.new }

    example 'without type' do
      memory.write :value, 'foo'
      expect(memory[:value]).to eq 'foo'
    end

    example 'relative date' do
      travel_to Date.new(2018, 10, 15)
      memory.write :value, '2018-10-20', :relative_date
      expect(memory[:value]).to eq 5
    end

    example 'relative month' do
      travel_to Date.new(2018, 10, 15)
      memory.write :value, '2018-11', :relative_month
      expect(memory[:value]).to eq 1
    end

    example 'relative year' do
      travel_to Date.new(2018, 10, 15)
      memory.write :value, '2018', :relative_year
      expect(memory[:value]).to eq 0
    end

    example 'invalid value' do
      %i(relative_date relative_month relative_year).each do |type|
        memory.write :value, 'invalid', type
        expect(memory[:value]).to eq nil

        memory.write :value, '', type
        expect(memory[:value]).to eq nil

        memory.write :value, nil, type
        expect(memory[:value]).to eq nil
      end
    end

  end

end
