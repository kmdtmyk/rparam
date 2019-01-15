# frozen_string_literal: true

module Rparam
  class Calculator

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

      if options[:inclusion].present?
        inclusion = Array.wrap options[:inclusion]
        if value.is_a? Array
          value = value & inclusion
        else
          value = nil unless value.in? inclusion
        end
      end

      if options.has_key? :exclusion
        exclusion = Array.wrap options[:exclusion]
        if value.is_a? Array
          value = value - exclusion
        else
          value = nil if value.in? exclusion
        end
      end

      if options[:default].present? and @params[name] != ''
        if options[:save] == :relative_date
          value = options[:default].to_s
        elsif value.nil?
          value = options[:default]
        end
      end

      if options[:type].present?
        value = Parser.parse(value, options[:type])
      end

      if value.nil? and @params[name] != ''
        value = options[:default]
      end

      @result[name] = value
    end

    def write_memory(name, value, options)
      if options[:save] == :relative_date
        date = Parser.parse_date(value)
        if date.nil?
          value = nil
        else
          value = (date - Time.zone.today).to_i
        end
      end
      @memory[name] = value
    end

    def read_memory(name, options)
      value = @memory[name]
      if options[:save] == :relative_date
        difference = Parser.parse_int(value)
        if difference.nil?
          value = ''
        else
          date = Time.zone.today + difference
          value = date.strftime '%F'
        end
      end
      value
    rescue
      nil
    end

    def result
      @result.dup
    end

    def memory
      @memory.dup
    end

  end
end
