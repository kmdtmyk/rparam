# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let!(:user){ User.create }
  before{ allow(@controller).to receive(:current_user).and_return(user) }

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

  describe 'save' do

    subject{ get :index, params: { sort: 'asc' } }

    it 'save' do
      expect{ subject }.to change{ ControllerParameter.count }.by 1
    end

  end

end
