# frozen_string_literal: true

class DemosController < ApplicationController
  before_action :apply_rparam

  def show
    @cookie = rparam_cookie
  end

end
