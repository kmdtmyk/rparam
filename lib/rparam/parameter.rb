# frozen_string_literal: true

module Rparam
  class Parameter < Hash

    def initialize
      super({})
    end

    def param(name, options = nil)
      if options.nil?
        return
      end
      self[name] = self[name].merge! options
    end

  end
end
