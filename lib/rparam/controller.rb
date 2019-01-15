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
          return JSON.parse(cookies[:rparam_memory], symbolize_names: true)
        end

        rparam_memory = user.rparam_memories.find_by(
          action: full_action_name,
        )
        if rparam_memory.nil?
          return nil
        end
        JSON.parse(rparam_memory.value, symbolize_names: true)
      rescue
        nil
      end

      def save_rparam_memory(memory)
        user = current_rparam_user
        if user.nil?
          cookies.permanent[:rparam_memory] = {
            value: memory.to_json,
            path: request.path,
            httponly: true,
          }
        else
          rparam_memory = user.rparam_memories.find_or_create_by(
            action: full_action_name,
          )
          rparam_memory.update(value: memory.to_json)
        end
      end

      def current_rparam_user
        current_user
      end

      def full_action_name
        parent_name = self.class.parent_name
        if parent_name.nil?
          "#{controller_name}##{action_name}"
        else
          "#{parent_name.gsub('::', '/').downcase}/#{controller_name}##{action_name}"
        end
      end

    end

    # class_methods do
    # end

  end
end
