# frozen_string_literal: true

class ExamplesController < ApplicationController
  before_action :apply_rparam
  before_action :render_nothing

  def index1
  end

  def index2
  end

  private

    def render_nothing
      render plain: nil
    end

end
