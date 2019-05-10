# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExamplesController, type: :controller do

  it do
    expect{ get :index }.not_to raise_error
  end

  describe 'inclusion' do

    let(:action){ :index_inclusion }
    subject{ @controller.params[:order] }

    it 'included value' do
      get action, params: { order: 'asc' }
      expect(subject).to eq 'asc'
    end

    it 'not included value' do
      get action, params: { order: 'foo' }
      expect(subject).to eq nil
    end

    describe 'with default value' do

      let(:action){ :index_inclusion_default }

      it 'included value' do
        get action, params: { order: 'asc' }
        expect(subject).to eq 'asc'
      end

      it 'not included value' do
        get action, params: { order: 'foo' }
        expect(subject).to eq 'asc'
      end

    end

  end

  describe 'type: Date' do

    let(:action){ :index_date }
    subject{ @controller.params[:date] }

    it 'valid date' do
      get action, params: { date: '2019-01-15' }
      expect(subject).to eq Date.new(2019, 1, 15)
    end

    it 'invalid date' do
      get action, params: { date: 'invalid' }
      expect(subject).to eq nil
    end

  end

end
