class EntityStore
  def create_entity(components:, **attributes)
    entity = Object.new

    data = {}
    entity.instance_variable_set(:@data, data)
    components.each do |component|
      component_module = Component[component]
      entity.extend component_module
      data[component] = component_module.default_values.dup
    end
    attributes.each do |name, value|
      entity.send("#{name}=", value)
    end

    entity
  end
end
