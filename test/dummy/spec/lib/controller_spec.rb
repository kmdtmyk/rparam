# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestsController, type: :controller do

  let!(:user){ User.create }
  before{ allow(@controller).to receive(:current_user).and_return(user) }

  describe 'apply_each_rparam' do

    describe 'inclusion' do

      example do
        get :index, params: { order: 'asc' }
        @controller.apply_each_rparam :order, inclusion: %w(asc desc)
        expect(@controller.params[:order]).to eq 'asc'

        get :index, params: { order: 'foo' }
        @controller.apply_each_rparam :order, inclusion: %w(asc desc)
        expect(@controller.params[:order]).to eq nil
      end

      describe 'with default value' do

        example do
          get :index, params: { order: 'asc' }
          @controller.apply_each_rparam :order, inclusion: %w(asc desc), default: 'asc'
          expect(@controller.params[:order]).to eq 'asc'

          get :index, params: { order: 'foo' }
          @controller.apply_each_rparam :order, inclusion: %w(asc desc), default: 'asc'
          expect(@controller.params[:order]).to eq 'asc'
        end

      end

    end

    describe 'type: Date' do

      example do
        get :index, params: { date: '2018-12-15' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq Date.new(2018, 12, 15)

        get :index, params: { date: 'invalid' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq nil
      end

    end

    describe 'save: true' do

      example do
        get :index, params: { order: 'asc' }
        @controller.apply_each_rparam :order, save: true
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 1

        get :index
        @controller.apply_each_rparam :order, save: true
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 1
      end

    end

  end

end
