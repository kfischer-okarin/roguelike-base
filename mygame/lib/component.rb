module Component
  class << self
    def define(name, &block)
      @definitions ||= {}
      @definitions[name] = Module.new do
        @name = name
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

  def attribute(name, default: nil)
    component_name = @name
    default_values[name] = default if default

    define_method(name) do
      @entity_component_data[component_name][name]
    end

    define_method("#{name}=") do |value|
      @entity_component_data[component_name][name] = value
    end
  end

  def default_values
    @default_values ||= {}
  end
end
