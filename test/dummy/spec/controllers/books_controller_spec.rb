# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  describe 'type: Date' do

    subject{ @controller.params[:from_date] }

    it 'valid date' do
      get :index, params: { from_date: '2019-01-15' }
      expect(subject).to eq Date.new(2019, 1, 15)
    end

    it 'invalid date' do
      get :index, params: { from_date: 'invalid' }
      expect(subject).to eq nil
    end

  end

end
