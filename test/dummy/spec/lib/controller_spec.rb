# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestsController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

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

    describe 'exclusion' do

      example do
        get :index, params: { value: 'a' }
        @controller.apply_each_rparam :value, exclusion: 'a'
        expect(@controller.params[:value]).to eq nil

        get :index, params: { value: 'a' }
        @controller.apply_each_rparam :value, exclusion: %w(a b c)
        expect(@controller.params[:value]).to eq nil

        get :index, params: { value: 'd' }
        @controller.apply_each_rparam :value, exclusion: %w(a b c)
        expect(@controller.params[:value]).to eq 'd'
      end

    end

    describe 'type: Date' do

      example 'date' do
        get :index, params: { date: '2018-05-15' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq Date.new(2018, 5, 15)
      end

      example 'month' do
        get :index, params: { date: '2018-05' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq Date.new(2018, 5, 1)

        get :index, params: { date: '2018-5' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq Date.new(2018, 5, 1)
      end

      example 'year' do
        get :index, params: { date: '2018' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq Date.new(2018, 1, 1)
      end

      example 'invalid date' do
        get :index, params: { date: 'invalid' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq nil
      end

      example 'with default value' do
        today = Date.today
        get :index
        @controller.apply_each_rparam :value, type: Date, default: today
        expect(@controller.params[:value]).to eq today

        get :index
        @controller.apply_each_rparam :value, type: Date, default: 7.days.ago
        expect(@controller.params[:value]).to eq today - 7

        get :index, params: { value: '' }
        @controller.apply_each_rparam :value, type: Date, default: today
        expect(@controller.params[:value]).to eq nil
      end

      example 'relative date with default value' do
        today = Date.today
        get :index
        @controller.apply_each_rparam :value, type: Date, save: :relative_date, default: today
        expect(@controller.params[:value]).to eq today
      end
    end

    describe 'type: Array' do

      example 'array' do
        get :index, params: { value: %w(a b c) }
        @controller.apply_each_rparam :value, type: Array
        expect(@controller.params[:value]).to eq %w(a b c)
      end

      example 'not array' do
        get :index, params: { value: 'invalid' }
        @controller.apply_each_rparam :value, type: Array
        expect(@controller.params[:value]).to eq []
      end

      example 'without parameter' do
        get :index
        @controller.apply_each_rparam :value, type: Array
        expect(@controller.params[:value]).to eq []
      end

      example 'with inclusion' do
        get :index, params: { value: %w(a b c) }
        @controller.apply_each_rparam :value, type: Array, inclusion: 'a'
        expect(@controller.params[:value]).to eq %w(a)

        get :index, params: { value: %w(a b c) }
        @controller.apply_each_rparam :value, type: Array, inclusion: %w(b c d)
        expect(@controller.params[:value]).to eq %w(b c)
      end

      example 'with exclusion' do
        get :index, params: { value: %w(a b c) }
        @controller.apply_each_rparam :value, type: Array, exclusion: 'a'
        expect(@controller.params[:value]).to eq %w(b c)

        get :index, params: { value: %w(a b c) }
        @controller.apply_each_rparam :value, type: Array, exclusion: %w(b c d)
        expect(@controller.params[:value]).to eq %w(a)

        get :index, params: { value: [nil, 1] }
        @controller.apply_each_rparam :value, type: Array, exclusion: ''
        expect(@controller.params[:value]).to eq ['1']
      end

      example 'with default value' do
        get :index
        @controller.apply_each_rparam :value, type: Array, default: %w(a b c)
        expect(@controller.params[:value]).to eq %w(a b c)
      end

    end

    describe 'save' do

      example 'true' do
        get :index, params: { order: 'asc' }
        @controller.apply_each_rparam :order, save: true
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 0

        get :index
        @controller.apply_each_rparam :order, save: true
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 0
      end

      example 'false' do
        get :index, params: { order: 'asc' }
        @controller.apply_each_rparam :order, save: false
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 0

        get :index
        @controller.apply_each_rparam :order, save: false
        expect(@controller.params[:order]).to eq nil
        expect(ControllerParameter.count).to eq 0
      end

    end

    describe 'login user' do

      let!(:user){ User.create }
      before{ allow(@controller).to receive(:current_user).and_return(user) }

      describe 'save' do

        example 'true' do
          get :index, params: { order: 'asc' }
          @controller.apply_each_rparam :order, save: true
          expect(@controller.params[:order]).to eq 'asc'
          expect(ControllerParameter.count).to eq 1

          get :index
          @controller.apply_each_rparam :order, save: true
          expect(@controller.params[:order]).to eq 'asc'
          expect(ControllerParameter.count).to eq 1
        end

        example 'false' do
          get :index, params: { order: 'asc' }
          @controller.apply_each_rparam :order, save: false
          expect(@controller.params[:order]).to eq 'asc'
          expect(ControllerParameter.count).to eq 0

          get :index
          @controller.apply_each_rparam :order, save: false
          expect(@controller.params[:order]).to eq nil
          expect(ControllerParameter.count).to eq 0
        end

      end

      describe 'save array' do
        example do
          get :index, params: { value: %w(a b c) }
          @controller.apply_each_rparam :value, type: Array, save: true
          expect(@controller.params[:value]).to eq %w(a b c)
          expect(ControllerParameter.count).to eq 1
          expect(ControllerParameter.first.value).to eq %w(a b c).to_s

          get :index
          @controller.apply_each_rparam :value, type: Array, save: true
          expect(@controller.params[:value]).to eq %w(a b c)
        end
      end

      describe 'save relative date' do

        example do
          travel_to Date.new(2018, 10, 15)
          get :index, params: { date: '2018-10-20' }
          @controller.apply_each_rparam :date, save: :relative_date
          expect(@controller.params[:date]).to eq '2018-10-20'
          expect(ControllerParameter.count).to eq 1
          expect(ControllerParameter.first.value).to eq '5'

          get :index
          @controller.apply_each_rparam :date, save: :relative_date
          expect(@controller.params[:date]).to eq '2018-10-20'

          travel 5.days
          get :index
          @controller.apply_each_rparam :date, save: :relative_date
          expect(@controller.params[:date]).to eq '2018-10-25'
        end

        example 'blank' do
          get :index, params: { date: '' }
          @controller.apply_each_rparam :date, save: :relative_date
          expect(@controller.params[:date]).to eq ''
          expect(ControllerParameter.count).to eq 1
          expect(ControllerParameter.first.value).to eq nil

          get :index
          @controller.apply_each_rparam :date, save: :relative_date
          expect(@controller.params[:date]).to eq ''
        end

        example 'without params' do
          get :index
          @controller.apply_each_rparam :date, save: :relative_date
          expect(@controller.params[:date]).to eq nil
          expect(ControllerParameter.count).to eq 0
        end

        example 'invalid date' do
          travel_to Date.new(2018, 10, 15)
          get :index, params: { date: 'invalid' }
          @controller.apply_each_rparam :date, save: :relative_date
          # expect(@controller.params[:date]).to eq ''
          expect(ControllerParameter.count).to eq 1
          expect(ControllerParameter.first.value).to eq nil

          get :index
          @controller.apply_each_rparam :date, save: :relative_date
          expect(@controller.params[:date]).to eq ''
        end

      end

    end

  end

end
