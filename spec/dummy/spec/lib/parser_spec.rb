# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Parser do
  include Rparam::Parser

  describe 'parse_date' do

    example '-' do
      expect(parse_date('2018-1-2')).to eq Date.new(2018, 1, 2)
      expect(parse_date('2018-3-04')).to eq Date.new(2018, 3, 4)
      expect(parse_date('2018-05-6')).to eq Date.new(2018, 5, 6)
      expect(parse_date('2018-07-08')).to eq Date.new(2018, 7, 8)
    end

    example '/' do
      expect(parse_date('2018/1/2')).to eq Date.new(2018, 1, 2)
      expect(parse_date('2018/3/04')).to eq Date.new(2018, 3, 4)
      expect(parse_date('2018/05/6')).to eq Date.new(2018, 5, 6)
      expect(parse_date('2018/07/08')).to eq Date.new(2018, 7, 8)
    end

    example 'without delimiter' do
      expect(parse_date('20180515')).to eq Date.new(2018, 5, 15)
    end

    example 'month (-)' do
      expect(parse_date('2018-1')).to eq Date.new(2018, 1, 1)
      expect(parse_date('2018-02')).to eq Date.new(2018, 2, 1)
    end

    example 'month (/)' do
      expect(parse_date('2018/1')).to eq Date.new(2018, 1, 1)
      expect(parse_date('2018/02')).to eq Date.new(2018, 2, 1)
    end

    example 'year' do
      expect(parse_date('2018')).to eq Date.new(2018, 1, 1)
    end

    example 'date' do
      expect(parse_date(Date.today)).to eq Date.today
    end

    example 'invalid' do
      expect(parse_date('')).to eq nil
      expect(parse_date(nil)).to eq nil
      expect(parse_date('invalid')).to eq nil
    end

  end

  describe 'parse_array' do

    example do
      expect(parse_array([])).to eq []
      expect(parse_array('[]')).to eq []
    end

    example 'invalid' do
      expect(parse_array('')).to eq nil
      expect(parse_array(nil)).to eq nil
      expect(parse_array('invalid')).to eq nil
    end

  end

  describe 'parse_boolean' do

    example 'true' do
      expect(parse_boolean(true)).to eq true
      expect(parse_boolean('true')).to eq true
      expect(parse_boolean('1')).to eq true
    end

    example 'false' do
      expect(parse_boolean(false)).to eq false
      expect(parse_boolean('false')).to eq false
      expect(parse_boolean('0')).to eq false
    end

    example 'invalid' do
      expect(parse_boolean('')).to eq nil
      expect(parse_boolean(nil)).to eq nil
    end

  end

  describe 'parse_int' do

    example do
      expect(parse_int(1234567890)).to eq 1234567890
      expect(parse_int('1234567890')).to eq 1234567890
    end

    example 'full-width character' do
      expect(parse_int('１２３４５６７８９０')).to eq 1234567890
    end

    example 'invalid' do
      expect(parse_int('')).to eq nil
      expect(parse_int(nil)).to eq nil
      expect(parse_int('invalid')).to eq nil
    end

  end

  describe 'parse_json' do

    example do
      expect(parse_json('{"foo":123}')).to eq({ foo: 123 })
      expect(parse_json('{"foo":"abc"}')).to eq({ foo: 'abc' })
    end

    example 'syntax error' do
      expect(parse_json('{"foo":123')).to eq nil
    end

    example 'invalid' do
      expect(parse_json('')).to eq nil
      expect(parse_json(nil)).to eq nil
      expect(parse_json('invalid')).to eq nil
    end

  end

end
