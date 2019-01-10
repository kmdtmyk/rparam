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
        if parameter.respond_to? action_name and parameter.method(action_name).owner == parameter_class
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

        if options[:default].present?
          if options[:save] == :relative_date
            value = options[:default] if value.blank?
          elsif value.nil?
            value = options[:default]
          end
        end

        if options[:type].present?
          value = Parser::parse(value, options[:type])
        end

        if value.nil? and options[:type] == Array
          value = []
        end

        params[name] = value
      end

      def save_parameter(name, value, options)
        if options[:save] == :relative_date
          date = Parser::parse_date(value)
          if date.nil?
            value = nil
          else
            value = (date - Time.zone.today).to_i
          end
        end
        user = current_rparam_user
        if user.nil?
          save_parameter_to_cookie(name, value)
        else
          controller_parameter = user.controller_parameters.find_or_create_by(
            action: full_action_name,
            name: name,
          )
          controller_parameter.update(value: value)
        end
      end

      def save_parameter_to_cookie(name, value)
        hash = rparam_cookie
        hash[name] = value
        cookies.permanent[:parameters] = {
          value: hash.to_json,
          path: request.path,
          httponly: true,
        }
      end

      def load_parameter(name, options)
        user = current_rparam_user
        if user.nil?
          value = rparam_cookie[name]
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

        if options[:save] == :relative_date
          difference = Parser::parse_int(value)
          if difference.nil?
            value = ''
          else
            date = Time.zone.today + difference
            value = date.strftime '%F'
          end
        end

        value
      end

      def rparam_cookie
        JSON.parse(cookies[:parameters], symbolize_names: true)
      rescue
        {}
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
