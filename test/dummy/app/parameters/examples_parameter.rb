# frozen_string_literal: true

class ExamplesParameter < Rparam::Parameter

  def index1
    param :date, type: Date
  end

  def index2
    param :sort, save: true
  end

end
