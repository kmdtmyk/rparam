# frozen_string_literal: true

module Rparam
  class Memory
    extend Forwardable
    using DateExt

    def_delegators :@memory, :[], :[]=, :has_key?, :merge!, :to_h

    def initialize(memory = {})
      @memory = memory
    end

    def read(name, type = nil)
      value = @memory[name]
      if type == :relative_date and @memory.has_key? name
        difference = Parser.parse_int(value)
        if difference.nil?
          return ''
        end
        date = Time.zone.today + difference
        date.strftime '%Y-%m-%d'
      elsif type == :relative_month and @memory.has_key? name
        difference = Parser.parse_int(value)
        if difference.nil?
          return ''
        end
        date = Time.zone.today.next_month difference
        date.strftime '%Y-%m'
      elsif type == :relative_year and @memory.has_key? name
        difference = Parser.parse_int(value)
        if difference.nil?
          return ''
        end
        date = Time.zone.today.next_year difference
        date.strftime '%Y'
      else
        value
      end
    rescue
      nil
    end

    def write(name, value, type = nil)
      if type == :relative_date
        date = Parser.parse_date(value)
        value = date&.difference_in_day
      elsif type == :relative_month
        date = Parser.parse_date(value)
        value = date&.difference_in_month
      elsif type == :relative_year
        date = Parser.parse_date(value)
        value = date&.difference_in_year
      end
      @memory[name] = value
    end

  end
end
