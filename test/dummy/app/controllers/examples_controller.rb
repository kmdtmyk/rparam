# frozen_string_literal: true

class ExamplesController < ApplicationController
  before_action :apply_rparam
  before_action :render_nothing

  def index_inclusion
  end

  def index_inclusion_default
  end

  def index_date
  end

  def index_save
  end

  private

    def render_nothing
      render plain: nil
    end

end
