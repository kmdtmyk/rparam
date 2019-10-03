# frozen_string_literal: true

class UserParameter < Rparam::Parameter

  def index
    param :sort, save: true
  end

end
