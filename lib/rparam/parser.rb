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
        if value.is_a? Date
          return value
        end

        if value.match /\d{4}/
          Date.parse("#{value}-01-01")
        elsif value.match /\d{4}[-\/]\d{1,2}/
          Date.parse("#{value}-01")
        else
          Date.parse(value)
        end
      rescue
        nil
      end

      def parse_int(value)
        Integer(value)
      rescue
        nil
      end

    end

  end
end
