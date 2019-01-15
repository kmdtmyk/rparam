# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Parser do
  include Rparam::Parser

  describe 'parse_date' do

    example do
      expect(parse_date(Date.today)).to eq Date.today
      expect(parse_date('2018-05-15')).to eq Date.new(2018, 5, 15)
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

  describe 'parse_int' do

    example do
      expect(parse_int(1)).to eq 1
      expect(parse_int('1')).to eq 1
    end

    example 'invalid' do
      expect(parse_int('')).to eq nil
      expect(parse_int(nil)).to eq nil
      expect(parse_int('invalid')).to eq nil
    end

  end

end
