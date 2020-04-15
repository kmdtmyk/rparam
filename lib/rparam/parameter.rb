# frozen_string_literal: true

module Rparam
  class Parameter

    def initialize
      @config = Hash.new({})
    end

    def param(name, options = nil, &block)
      return if name.nil?

      if block_given?
        child = self.class.new
        child.instance_exec(&block)
        @config[name] = { type: Hash, schema: child.to_h }
        return
      end

      if options.nil?
        return
      end

      @config[name] = @config[name].merge options
    end

    def to_h
      @config.dup
    end

    def each
      @config.each do |name, options|
        yield name, options
      end
    end

  end
end
