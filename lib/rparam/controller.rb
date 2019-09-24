# frozen_string_literal: true

module Rparam
  module Controller
    extend ActiveSupport::Concern

    included do

      def rparam_parameter
        class_name = self.class.name[0..-11] + 'Parameter'
        class_name.constantize.new
      rescue
        nil
      end

      def apply_rparam
        parameter = rparam_parameter
        return if parameter.nil?
        return unless parameter.respond_to? action_name
        # return unless parameter.method(action_name).owner == parameter.class
        parameter.send action_name

        calculator = Calculator.new(params, rparam_memory)

        parameter.each do |name, options|
          calculator.add name, options
        end

        params.merge! calculator.result
        save_rparam_memory calculator.memory
      end

      def rparam_memory
        user = current_rparam_user
        if user.nil?
          return rparam_cookie
        end

        begin
          rparam_memory = user.rparam_memories.find_by(
            action: rparam_key,
          )
        rescue NoMethodError
          return rparam_cookie
        end

        Parser.parse_json(rparam_memory.value)
      rescue
        nil
      end

      def save_rparam_memory(memory)
        user = current_rparam_user

        if user.nil?
          self.rparam_cookie = memory
          return
        end

        begin
          rparam_memory = user.rparam_memories.find_or_create_by(
            action: rparam_key,
          )
          rparam_memory.update(value: memory.to_json)
        rescue NoMethodError
          self.rparam_cookie = memory
        end

      end

      def current_rparam_user
        current_user if defined? current_user
      end

      def rparam_key
        if self.class.respond_to? :module_parent_name
          parent_name = self.class.module_parent_name
        else
          parent_name = self.class.parent_name
        end

        if parent_name.nil?
          "#{controller_name}##{action_name}"
        else
          "#{parent_name.gsub('::', '/').underscore}/#{controller_name}##{action_name}"
        end
      end

      def rparam_cookie
        cookie = cookies.signed[rparam_key] || cookies[rparam_key]
        Parser.parse_json(cookie)
      end

      def rparam_cookie=(value)
        cookies.permanent.signed[rparam_key] = {
          value: value.to_json,
          httponly: true,
        }
      end

    end

    # class_methods do
    # end

  end
end
