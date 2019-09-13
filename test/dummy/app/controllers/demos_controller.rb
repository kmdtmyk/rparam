# frozen_string_literal: true

class DemosController < ApplicationController
  before_action :apply_rparam

  def show
    @cookie = cookies.signed[full_action_name]
  end

end
