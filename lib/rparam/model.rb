# frozen_string_literal: true

module Rparam
  module Model
    extend ActiveSupport::Concern

    # included do
    # end

    class_methods do
      def acts_as_rparam_parent
        has_many :controller_parameters, as: :parent
      end
    end

  end
end
