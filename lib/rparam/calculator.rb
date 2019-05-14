# frozen_string_literal: true

module Rparam
  class Calculator
    using DateExt

    def initialize(params = nil, memory = nil)
      @params = params || {}
      @memory = {}
      @result = {}
      begin
        @memory.merge! memory
      rescue
      end
    end

    def add(name, options)
      options ||= {}
      value = @params[name]

      if options[:save].present?
        if value.nil?
          value = read_memory(name, options)
        else
          write_memory(name, value, options)
        end
      end

      if options.has_key? :inclusion
        value = apply_inclusion(value, options[:inclusion])
      end

      if options.has_key? :exclusion
        value = apply_exclusion(value, options[:exclusion])
      end

      if options.has_key? :default and value.nil?
        value = default_value(options)
      end

      if options.has_key? :type
        value = apply_type(value, options[:type])
      end

      if options[:type] == Integer and value.present?
        value = clamp(value, options)
      end

      @result[name] = value
    end

    def write_memory(name, value, options)
      if options[:save] == :relative_date
        date = Parser.parse_date(value)
        value = date&.difference_in_day
      elsif options[:save] == :relative_month
        date = Parser.parse_date(value)
        value = date&.difference_in_month
      elsif options[:save] == :relative_year
        date = Parser.parse_date(value)
        value = date&.difference_in_year
      end
      @memory[name] = value
    end

    def read_memory(name, options)
      value = @memory[name]
      if options[:save] == :relative_date and @memory.has_key? name
        difference = Parser.parse_int(value)
        if difference.nil?
          return ''
        end
        date = Time.zone.today + difference
        date.strftime '%Y-%m-%d'
      elsif options[:save] == :relative_month and @memory.has_key? name
        difference = Parser.parse_int(value)
        if difference.nil?
          return ''
        end
        date = Time.zone.today.next_month difference
        date.strftime '%Y-%m'
      elsif options[:save] == :relative_year and @memory.has_key? name
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

    def result
      @result.dup
    end

    def memory
      @memory.dup
    end

    private

      def apply_inclusion(value, inclusion)
        inclusion = Array.wrap inclusion

        if value.is_a? Array
          return value & inclusion
        end

        unless value.in? inclusion
          return nil
        end

        value
      end

      def apply_exclusion(value, exclusion)
        exclusion = Array.wrap exclusion

        if value.is_a? Array
          return value - exclusion
        end

        if value.in? exclusion
          return nil
        end

        value
      end

      def apply_type(value, type)

        if type.present?
          value = Parser.parse(value, type)
        end

        if value.nil? && type == Array
          value = []
        end

        if type.is_a? Hash
          calculator = Calculator.new(value)
          type.each do |name, options|
            calculator.add name, options
          end
          value = calculator.result
        end

        value
      end

      def default_value(options)
        value = options[:default]
        if options[:save] == :relative_date
          value.to_s
        elsif options[:save] == :relative_month
          date = Parser.parse_date(value)
          date.start_of_month.strftime '%Y-%m'
        elsif options[:save] == :relative_year
          date = Parser.parse_date(value)
          date.start_of_month.strftime '%Y'
        else
          value
        end
      end

      def clamp(value, options)
        min = options[:min]
        max = options[:max]

        if min.present? and value < min
          value = min
        end

        if max.present? and max < value
          value = max
        end

        value
      end

  end
end
