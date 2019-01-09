# frozen_string_literal: true

module Rparam
  module Controller
    extend ActiveSupport::Concern

    included do

      def apply_rparam
        if parameter_class.nil?
          return
        end
        parameter = parameter_class.new
        if parameter.respond_to? action_name
          parameter.send action_name
        end

        parameter.each do |name, options|
          apply_each_rparam(name, options)
        end
      end

      def apply_each_rparam(name, options)
        options ||= {}
        value = params[name]

        if options[:save] == true
          if value.nil?
            controller_parameter = load_parameter(name)
            unless controller_parameter.nil?
              value = controller_parameter.value
            end
          else
            save_parameter(name, value)
          end
        end

        if options[:inclusion].present?
          value = nil unless value.in? options[:inclusion]
        end

        if options[:type].present?
          value = Parser::parse(value, options[:type])
        end

        if value.nil? && options[:default].present?
          value = options[:default]
        end

        params[name] = value
      end

      def save_parameter(name, value)
        user = current_rparam_user
        controller_parameter = user.controller_parameters.find_or_create_by(
          action: full_action_name,
          name: name,
        )
        controller_parameter.update(value: value)
      end

      def load_parameter(name)
        user = current_rparam_user
        user.controller_parameters.find_by(
          action: full_action_name,
          name: name,
        )
      end

      def current_rparam_user
        current_user
      end

      def full_action_name
        "#{controller_name}##{action_name}"
      end

      def parameter_class
        class_name = self.class.name[0..-11] + 'Parameter'
        class_name.constantize
      rescue
        nil
      end

    end

    # class_methods do
    # end

  end
end
