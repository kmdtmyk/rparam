# frozen_string_literal: true

module Rparam
  module Parser
    module_function

    def parse(value, type)
      if type == Date
        parse_date(value)
      elsif type == Integer
        parse_int(value)
      elsif type == :boolean
        parse_boolean(value)
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

      if value.is_a? String
        if value.match(/^\d{4}$/)
          Date.parse("#{value}-01-01")
        elsif value.match(/^\d{4}[-\/]\d{1,2}$/)
          Date.parse("#{value}-01")
        else
          Date.parse(value)
        end
      elsif value.respond_to? :to_date
        value.to_date
      end
    rescue
      nil
    end

    def parse_array(value)
      if value.is_a? Array
        return value
      end
      parsed_value = JSON.parse(value)

      if parsed_value.is_a? Array
        parsed_value
      end
    rescue
      return nil
    end

    def parse_int(value)
      if value.is_a? String
        value = value.tr('０-９', '0-9')
      end
      Integer(value)
    rescue
      nil
    end

    def parse_boolean(value)
      value = value.to_s
      if %w(true 1).include? value
        true
      elsif %w(false 0).include? value
        false
      else
        nil
      end
    rescue
      nil
    end

    def parse_json(value)
      JSON.parse(value, symbolize_names: true)
    rescue
      nil
    end

  end
end
