# frozen_string_literal: true

class ExamplesParameter < Rparam::Parameter

  def index_inclusion
    param :order, inclusion: %w(asc desc)
  end

  def index_inclusion_default
    param :order, inclusion: %w(asc desc), default: 'asc'
  end

  def index_date
    param :date, type: Date
  end

  def index_save
    param :sort, save: true
  end

end
