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
