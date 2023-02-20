class EntityStore
  def create_entity(components:, **attributes)
    entity = Object.new

    data = { components: {} }
    component_data = data[:components]
    entity.instance_variable_set(:@entity_data, data)
    entity.instance_variable_set(:@entity_component_data, component_data)
    components.each do |component|
      component_module = Component[component]
      entity.extend component_module
      component_data[component] = component_module.default_values.dup
    end
    attributes.each do |name, value|
      entity.send("#{name}=", value)
    end

    entity
  end
end
