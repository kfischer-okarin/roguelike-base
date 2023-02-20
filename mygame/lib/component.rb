module Component
  class << self
    def define(name, &block)
      @definitions ||= {}
      @definitions[name] = Module.new do
        extend Component
      end
      @definitions[name].class_eval(&block)
    end

    def defined_types
      @definitions.keys
    end

    def [](name)
      @definitions[name]
    end

    def clear_definitions
      @definitions = {}
    end
  end
end
