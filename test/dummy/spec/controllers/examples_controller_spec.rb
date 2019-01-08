# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExamplesController, type: :controller do

  let!(:user){ User.create }
  before{ allow(@controller).to receive(:current_user).and_return(user) }

  describe 'type: Date' do

    let(:action){ :index1 }
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

  describe 'save' do

    let(:action){ :index2 }
    subject{ get action, params: { sort: 'asc' } }

    context 'first time' do
      it{ expect{ subject }.to change{ ControllerParameter.count }.by 1 }
    end

    context 'next time' do
      before{ subject }
      it{ expect{ subject }.to change{ ControllerParameter.count }.by 0 }
    end

    context 'next time without param' do
      subject do
        get action, params: { sort: 'asc' }
        get action
        @controller.params[:sort]
      end
      it{ expect(subject).to eq 'asc' }
    end

  end


end
