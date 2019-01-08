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

    context 'first time' do
      it{ expect{ subject }.to change{ ControllerParameter.count }.by 1 }
    end

    context 'next time' do
      before{ subject }
      it{ expect{ subject }.to change{ ControllerParameter.count }.by 0 }
    end

    context 'next time without param' do
      subject do
        get :index, params: { sort: 'asc' }
        get :index
        @controller.params[:sort]
      end
      it{ expect(subject).to eq 'asc' }
    end

  end

end
