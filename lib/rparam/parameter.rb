# frozen_string_literal: true

module Rparam
  class Parameter

    attr_reader :config

    def initialize
      @config = Hash.new({})
    end

    def param(name, options = nil)
      if options.nil?
        return
      end
      @config[name] = @config[name].merge options
    end

    def each
      @config.each do |name, options|
        yield name, options
      end
    end

  end
end
