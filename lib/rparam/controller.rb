# frozen_string_literal: true

module Rparam
  module Controller
    extend ActiveSupport::Concern

    included do

      def apply_rparam
        if parameter_class.nil?
          return
        end
        parameter = parameter_class.new(self)
        if parameter.respond_to? action_name
          parameter.send action_name
        end
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
