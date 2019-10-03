# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GuestController, type: :controller do

  describe 'save' do

    let(:action){ :index }
    subject{ get action, params: { sort: 'asc' } }

    it do
      expect{ subject }.to change{ RparamMemory.count }.by 0
      expect(response.cookies).to_not eq({})
    end

  end

end
