# frozen_string_literal: true

class ExamplesController < ApplicationController
  before_action :apply_rparam

  def index
    render plain: nil
  end

  def index_inclusion
    render plain: nil
  end

  def index_inclusion_default
    render plain: nil
  end

  def index_date
    render plain: nil
  end

end
