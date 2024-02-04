class ComponentDefinitions
  def initialize
    @definitions = {}
  end

  def define(name, &block)
    component = Module.new do
      @name = name
      @default_values = {}
      @attributes = {}
      @entity_attribute = {}
      @methods = {}
      extend Component
    end
    component.class_eval(&block)
    @definitions[name] = component
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
      @default_values[name] = default if default
      @attributes[name] = true
    end

    def entity_attribute(name)
      @entity_attribute[name] = true
    end

    def method(name, &block)
      @methods[name] = block
    end

    def build_default_values
      @default_values.dup
    end

    def attach_to(entity, **attributes)
      entity_component_data = entity.instance_variable_get(:@entity_component_data)
      component_data = entity_component_data[@name] = build_default_values.merge(attributes)

      @attributes.each_key do |name|
        entity.define_singleton_method(name) do
          component_data[name]
        end

        entity.define_singleton_method("#{name}=") do |value|
          component_data[name] = value
        end
      end

      @entity_attribute.each_key do |name|
        entity.define_singleton_method(name) do
          @entity_store[component_data[name]]
        end

        entity.define_singleton_method("#{name}=") do |value|
          component_data[name] = value.id
        end
      end

      @methods.each do |name, block|
        entity.define_singleton_method(name, &block)
      end
    end
  end
end
