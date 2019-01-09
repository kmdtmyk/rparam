# frozen_string_literal: true

module Rparam
  module Parser

    class << self

      def parse(value, type)
        if type == Date
          return parse_date(value)
        end
        value
      end

      def parse_date(value)
        Date.parse(value)
      rescue
        nil
      end

    end

  end
end
