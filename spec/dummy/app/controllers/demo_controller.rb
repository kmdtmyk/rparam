# frozen_string_literal: true

class DemoController < ApplicationController
  before_action :apply_rparam

  def index
    @cookie = rparam_cookie
  end

end
