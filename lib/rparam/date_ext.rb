# frozen_string_literal: true

module DateExt
  refine Date do

    def difference_in_day(target = Time.zone.today)
      (self - target).to_i
    end

    def difference_in_month(target = Time.zone.today)
      (self.year * 12 + self.month) - (target.year * 12 + target.month)
    end

    def difference_in_year(target = Time.zone.today)
      self.year - target.year
    end

    def start_of_month
      self - self.day + 1
    end

  end
end
