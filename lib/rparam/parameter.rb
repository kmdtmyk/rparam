# frozen_string_literal: true

module Rparam
  class Parameter

    def initialize(controller)
      @params = controller.params
    end

    def param(name)
      @params[name] = nil
    end

  end
end
