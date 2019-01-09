# frozen_string_literal: true

module Rparam
  class Parameter

    def initialize(controller)
      @controller = controller
    end

    def param(name, options = nil)
      @controller.apply_each_rparam(name, options)
    end

  end
end
