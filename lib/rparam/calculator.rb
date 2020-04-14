# frozen_string_literal: true

module Rparam
  class Calculator
    using DateExt

    def initialize(params = nil, memory = nil)
      @params = params || {}
      @memory = Memory.new
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
          value = @memory.read(name, options[:save])
        else
          @memory.write(name, value, options[:save])
        end
      end

      if options.has_key?(:inclusion)
        value = Transformer.inclusion(value, options[:inclusion])
      end

      if options.has_key?(:exclusion)
        value = Transformer.exclusion(value, options[:exclusion])
      end

      if options.has_key?(:default) && value.nil?
        value = default_value(options)
      end

      if options.has_key?(:type)
        value = apply_type(name, value, options[:type])
      end

      if options.has_key?(:min) || options.has_key?(:max)
        value = Transformer.clamp(value, options[:min], options[:max])
      end

      @result[name] = value
    end

    def result
      @result.dup
    end

    def memory
      @memory.to_h
    end

    private

      def apply_type(name, value, type)

        if type.present?
          value = Parser.parse(value, type)
        end

        if value.nil? && type == Array
          value = []
        end

        if type.is_a? Hash
          calculator = Calculator.new(value, @memory[name])
          type.each do |name, options|
            calculator.add name, options
          end
          value = calculator.result
          if @memory[name].nil?
            @memory[name] = {}
          end
          @memory[name].merge! calculator.memory
        end

        value
      end

      def default_value(options)
        default = options[:default]
        value = if default.is_a? Proc
          default.call
        else
          default
        end

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

  end
end
