# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestsController, type: :controller do

  let!(:user){ User.create }
  before{ allow(@controller).to receive(:current_user).and_return(user) }

  describe 'apply_each_rparam' do

    describe 'type: Date' do

      it do
        get :index, params: { date: '2018-12-15' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq Date.new(2018, 12, 15)
      end

    end

  end

end
