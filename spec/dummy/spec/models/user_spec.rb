# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  example 'destory assosiated records when user is deleted' do
    user = User.create
    user.rparam_memories.create
    expect{ user.destroy }.to change{ RparamMemory.count }.from(1).to(0)
  end

end
