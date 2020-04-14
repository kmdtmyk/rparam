# frozen_string_literal: true

module Rparam
  module Transformer
    module_function

    def inclusion(value, target)
      array = Array.wrap target

      if value.is_a? Array
        return value & array
      end

      unless value.in? array
        return nil
      end

      value
    end

    def exclusion(value, target)
      array = Array.wrap target

      if value.is_a? Array
        return value - array
      end

      if value.in? array
        return nil
      end

      value
    end

    def clamp(value, min, max)
      return if value.nil?

      if min.present? && value < min
        value = min
      end

      if max.present? && max < value
        value = max
      end

      value
    end

  end
end
