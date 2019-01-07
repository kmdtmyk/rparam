# frozen_string_literal: true

module Rparam
  class Parameter

    def initialize(params)
      @params = params
    end

    private

      def param(name, options = nil)
        options ||= {}
        value = @params[name]

        if options[:type] == Date
          value = parse_date(value)
        end

        if value.nil? && options[:default].present?
          value = options[:default]
        end

        @params[name] = value
      end

      def parse_date(value)
        Date.parse(value)
      rescue
        nil
      end

  end
end
