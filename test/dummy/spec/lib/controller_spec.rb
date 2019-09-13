# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestsController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

  describe 'parameter' do

    let(:parameter){ Rparam::Parameter.new }
    before{ allow(@controller).to receive(:rparam_parameter).and_return(parameter) }

    example 'default value' do
      def parameter.index
        param :value, default: 'foo'
      end

      get :index, params: { value: 'bar' }
      expect(@controller.params[:value]).to eq 'bar'

      get :index
      expect(@controller.params[:value]).to eq 'foo'
    end

  end

  describe 'rparam_key' do
    it do
      get :index
      expect(@controller.rparam_key).to eq 'tests#index'
    end
  end

  describe 'rparam_cookie' do

    let(:cookie_name){ @controller.rparam_key }

    example do
      @request.cookies[cookie_name] = '{"foo":123}'
      expect(@controller.rparam_cookie).to eq({ foo: 123 })
    end

    example 'invalid value' do
      @request.cookies[cookie_name] = '{invalid}'
      expect(@controller.rparam_cookie).to eq nil
    end

  end

  describe 'rparam_cookie=' do

    let(:cookie_name){ @controller.rparam_key }
    let(:cookies){ @controller.send :cookies }

    example do
      @controller.rparam_cookie = { foo: 123 }
      expect(cookies.signed[cookie_name]).to eq '{"foo":123}'

      @controller.rparam_cookie = { bar: 456 }
      expect(cookies.signed[cookie_name]).to eq '{"bar":456}'
    end

  end

end

RSpec.describe Foo::TestsController, type: :controller do

  describe 'rparam_key' do
    it do
      get :index
      expect(@controller.rparam_key).to eq 'foo/tests#index'
    end
  end

end

RSpec.describe Foo::Bar::TestsController, type: :controller do

  describe 'rparam_key' do
    it do
      get :index
      expect(@controller.rparam_key).to eq 'foo/bar/tests#index'
    end
  end

end
