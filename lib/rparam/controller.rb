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

        if options[:save].present?
          if value.nil?
            value = load_parameter(name, options)
          else
            save_parameter(name, value, options)
          end
        end

        if options[:inclusion].present?
          value = nil unless value.in? options[:inclusion]
        end

        if options[:type].present?
          value = Parser::parse(value, options[:type])
        end

        if value.nil? and options[:default].present?
          value = options[:default]
        end

        params[name] = value
      end

      def save_parameter(name, value, options)
        if options[:save].is_a? Hash and options[:save][:relative_by].present?
          value = Parser::parse(value, options[:type]) - options[:save][:relative_by]
          value = value.to_i
        end
        user = current_rparam_user
        if user.nil?
          cookies["#{full_action_name},#{name}"] = value
        else
          controller_parameter = user.controller_parameters.find_or_create_by(
            action: full_action_name,
            name: name,
          )
          controller_parameter.update(value: value)
        end
      end

      def load_parameter(name, options)
        user = current_rparam_user
        if user.nil?
          value = cookies["#{full_action_name},#{name}"]
        else
          controller_parameter = user.controller_parameters.find_by(
            action: full_action_name,
            name: name,
          )
          if controller_parameter.nil?
            return nil
          end
          value = controller_parameter.value
        end
        if options[:save].is_a? Hash and options[:save][:relative_by].present?
          value = options[:save][:relative_by] + value.to_i
        end
        value
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
