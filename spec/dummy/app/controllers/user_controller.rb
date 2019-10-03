# frozen_string_literal: true

class UserController < ApplicationController
  before_action :apply_rparam

  def current_user
  end

  def index
    render plain: nil
  end

end
