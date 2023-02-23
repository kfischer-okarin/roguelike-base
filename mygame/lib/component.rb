module Component
  # A component is a particular lens through which we view an entity.
  # Possible kinds of components:
  # - A Role an entity plays (The entity acts as a ...)
  # - The type/class of an entity (The entity is a ...)
  # - A distinctive property of an entity (The entity has a/is ...)
  # - A capability of an entity (The entity can ...)
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
end
