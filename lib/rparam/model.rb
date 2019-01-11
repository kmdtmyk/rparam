# frozen_string_literal: true

module Rparam
  module Model
    extend ActiveSupport::Concern

    # included do
    # end

    class_methods do
      def acts_as_rparam_user
        has_many :rparam_memories, as: :user
      end
    end

  end
end
