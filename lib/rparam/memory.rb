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
      return unless @memory.has_key? name
      if type == :relative_date
        read_relative_date(name)
      elsif type == :relative_month
        read_relative_month(name)
      elsif type == :relative_year
        read_relative_year(name)
      else
        @memory[name]
      end
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

    private

      def read_relative_date(name)
        value = @memory[name]
        difference = Parser.parse_int(value)
        if difference.nil?
          ''
        else
          date = Time.zone.today + difference
          date.strftime '%Y-%m-%d'
        end
      end

      def read_relative_month(name)
        value = @memory[name]
        difference = Parser.parse_int(value)
        if difference.nil?
          ''
        else
          date = Time.zone.today.next_month difference
          date.strftime '%Y-%m'
        end
      end

      def read_relative_year(name)
        value = @memory[name]
        difference = Parser.parse_int(value)
        if difference.nil?
          ''
        else
          date = Time.zone.today.next_year difference
          date.strftime '%Y'
        end
      end
  end
end
