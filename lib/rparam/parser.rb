# frozen_string_literal: true

module Rparam
  module Parser

    class << self

      def parse(value, type)
        if type == Date
          parse_date(value)
        elsif type == Array
          parse_array(value)
        else
          value
        end
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

      def parse_array(value)
        if value.is_a? Array
          return value
        end
        JSON.parse(value)
      rescue
        return []
      end

      def parse_int(value)
        Integer(value)
      rescue
        nil
      end

    end

  end
end
