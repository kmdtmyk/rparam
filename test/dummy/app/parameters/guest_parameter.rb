# frozen_string_literal: true

class GuestParameter < Rparam::Parameter

  def index
    param :sort, save: true
  end

end
