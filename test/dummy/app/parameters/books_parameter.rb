# frozen_string_literal: true

class BooksParameter < Rparam::Parameter

  def index
    param :from_date, type: Date
    param :sort, save: true
  end

end
