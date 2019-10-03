# frozen_string_literal: true

class TestsController < ApplicationController
  before_action :apply_rparam

  def index
    render plain: nil
  end

end
