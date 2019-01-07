# frozen_string_literal: true

module Rparam
  class Parameter

    def initialize(controller)
      @params = controller.params
    end

    private

      def param(name, options = nil)
        options ||= {}
        value = @params[name]
        if options[:type] == Date
          @params[name] = parse_date(value)
        end
      end

      def parse_date(value)
        Date.parse(value)
      rescue
        nil
      end

  end
end
