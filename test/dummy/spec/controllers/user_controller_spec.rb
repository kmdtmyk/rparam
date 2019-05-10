# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserController, type: :controller do

  before{ allow(@controller).to receive(:current_user).and_return(user) }

  describe 'logged in' do
    let!(:user){ User.create }

    describe 'save' do

      let(:action){ :index }
      subject{ get action, params: { sort: 'asc' } }

      context 'first time' do
        it do
          expect{ subject }.to change{ RparamMemory.count }.by 1
          expect(response.cookies).to eq({})
        end
      end

      context 'next time' do
        before{ subject }
        it do
          expect{ subject }.to change{ RparamMemory.count }.by 0
          expect(response.cookies).to eq({})
        end
      end

      context 'next time without param' do
        subject do
          get action, params: { sort: 'asc' }
          get action
          @controller.params[:sort]
        end
        it do
          expect(subject).to eq 'asc'
          expect(response.cookies).to eq({})
        end
      end

    end

  end

  describe 'not logged in' do
    let!(:user){ nil }

    describe 'save' do

      let(:action){ :index }
      subject{ get action, params: { sort: 'asc' } }

      it do
        expect{ subject }.to change{ RparamMemory.count }.by 0
        expect(response.cookies).to_not eq({})
      end

    end

  end

end
