# frozen_string_literal: true

module Rparam
  class Parameter

    def initialize(controller)
      @controller = controller
    end

    private

      def params
        @controller.params
      end

      def param(name, options = nil)
        options ||= {}
        value = params[name]

        if options[:save] == true
          if value.nil?
            controller_parameter = load(name)
            unless controller_parameter.nil?
              value = controller_parameter.value
            end
          else
            save(name, value)
          end
        end

        if options[:inclusion].present?
          value = nil unless value.in? options[:inclusion]
        end

        if options[:type] == Date
          value = parse_date(value)
        end

        if value.nil? && options[:default].present?
          value = options[:default]
        end

        params[name] = value
      end

      def parse_date(value)
        Date.parse(value)
      rescue
        nil
      end

      def save(name, value)
        user = @controller.current_user
        controller_parameter = user.controller_parameters.find_or_create_by(
          action: full_action_name,
          name: name,
        )
        controller_parameter.update(value: value)
      end

      def load(name)
        user = @controller.current_user
        user.controller_parameters.find_by(
          action: full_action_name,
          name: name,
        )
      end

      def full_action_name
        "#{@controller.controller_name}##{@controller.action_name}"
      end

  end
end
