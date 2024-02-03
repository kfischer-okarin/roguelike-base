class ComponentDefinitions
  def initialize
    @definitions = {}
  end

  def define(name, &block)
    @definitions[name] = Module.new do
      @name = name
      @attributes = {}
      extend Component
    end
    @definitions[name].class_eval(&block)
  end

  def [](name)
    @definitions[name]
  end

  def defined_types
    @definitions.keys
  end

  def clear
    @definitions = {}
  end

  module Component
    def attribute(name, default: nil)
      default_values[name] = default if default
      @attributes[name] = { default: default }
    end

    def entity_attribute(name)
      component_name = @name

      define_method(name) do
        @entity_store[@entity_component_data[component_name][name]]
      end

      define_method("#{name}=") do |value|
        @entity_component_data[component_name][name] = value.id
      end
    end

    def default_values
      @default_values ||= {}
    end

    def extend_object(obj)
      super(obj)

      component_data = obj.instance_variable_get(:@entity_component_data)[@name]
      @attributes.each do |name, options|
        obj.define_singleton_method(name) do
          component_data[name]
        end

        obj.define_singleton_method("#{name}=") do |value|
          component_data[name] = value
        end
      end
    end
  end
end
