class ComponentDefinitions
  def initialize
    @definitions = {}
  end

  def define(name, &block)
    component = Component.new(name)
    component.instance_eval(&block)
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

  class Component
    def initialize(name)
      @name = name
      @default_values = {}
      @attributes = {}
      @entity_attribute = {}
      @methods = {}
    end

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
      DeepDup.dup(@default_values)
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

    def to_s
      "Component(#{@name})"
    end
  end
end
