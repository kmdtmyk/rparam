# frozen_string_literal: true

class DemosParameter < Rparam::Parameter

  def index
    param :from_date, type: Date, save: :relative_date, default: Time.zone.today - 7
    param :to_date, type: Date, save: :relative_date
    param :checkbox, type: Array, save: true, exclusion: '', default: %w(value1)
  end

end
