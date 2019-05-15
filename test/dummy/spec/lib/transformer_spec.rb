# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rparam::Transformer do

  describe 'inclusion' do

    example do
      expect(Rparam::Transformer.inclusion('a', 'a')).to eq 'a'
      expect(Rparam::Transformer.inclusion('b', 'a')).to eq nil
      expect(Rparam::Transformer.inclusion('a', %w(a b c))).to eq 'a'
      expect(Rparam::Transformer.inclusion('d', %w(a b c))).to eq  nil
    end

    example 'array' do
      expect(Rparam::Transformer.inclusion(%w(a b c), 'a')).to eq %w(a)
      expect(Rparam::Transformer.inclusion(%w(a b c), 'd')).to eq []
      expect(Rparam::Transformer.inclusion(%w(a b c), %w(a b c))).to eq %w(a b c)
      expect(Rparam::Transformer.inclusion(%w(a b c), %w(d))).to eq []
    end

  end

  describe 'exclusion' do

    example do
      expect(Rparam::Transformer.exclusion('a', 'a')).to eq nil
      expect(Rparam::Transformer.exclusion('b', 'a')).to eq 'b'
      expect(Rparam::Transformer.exclusion('a', %w(a b c))).to eq nil
      expect(Rparam::Transformer.exclusion('d', %w(a b c))).to eq 'd'
    end

    example 'array' do
      expect(Rparam::Transformer.exclusion(%w(a b c), 'a')).to eq %w(b c)
      expect(Rparam::Transformer.exclusion(%w(a b c), 'd')).to eq %w(a b c)
      expect(Rparam::Transformer.exclusion(%w(a b c), %w(a b c))).to eq []
      expect(Rparam::Transformer.exclusion(%w(a b c), %w(d))).to eq %w(a b c)
    end

  end

  describe 'clamp' do

    example 'min' do
      expect(Rparam::Transformer.clamp(-1, 0, nil)).to eq 0
      expect(Rparam::Transformer.clamp(0, 0, nil)).to eq 0
      expect(Rparam::Transformer.clamp(1, 0, nil)).to eq 1
      expect(Rparam::Transformer.clamp(nil, 0, nil)).to eq nil
    end

    example 'max' do
      expect(Rparam::Transformer.clamp(9, nil, 10)).to eq 9
      expect(Rparam::Transformer.clamp(10, nil, 10)).to eq 10
      expect(Rparam::Transformer.clamp(11, nil, 10)).to eq 10
      expect(Rparam::Transformer.clamp(nil, nil, 10)).to eq nil
    end

    example 'min and max' do
      expect(Rparam::Transformer.clamp(-1, 0, 10)).to eq 0
      expect(Rparam::Transformer.clamp(0, 0, 10)).to eq 0
      expect(Rparam::Transformer.clamp(1, 0, 10)).to eq 1
      expect(Rparam::Transformer.clamp(9, 0, 10)).to eq 9
      expect(Rparam::Transformer.clamp(10, 0, 10)).to eq 10
      expect(Rparam::Transformer.clamp(11, 0, 10)).to eq 10
      expect(Rparam::Transformer.clamp(nil, 0, 10)).to eq nil
    end

    example 'min and max (min > max)' do
      expect(Rparam::Transformer.clamp(-1, 10, 0)).to eq 0
      expect(Rparam::Transformer.clamp(0, 10, 0)).to eq 0
      expect(Rparam::Transformer.clamp(1, 10, 0)).to eq 0
      expect(Rparam::Transformer.clamp(9, 10, 0)).to eq 0
      expect(Rparam::Transformer.clamp(10, 10, 0)).to eq 0
      expect(Rparam::Transformer.clamp(11, 10, 0)).to eq 0
      expect(Rparam::Transformer.clamp(nil, 10, 0)).to eq nil
    end

  end

end
