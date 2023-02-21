class EntityStore
  def initialize
    @data = { next_id: 0 }
  end

  def create_entity(components:, **attributes)
    entity = Entity.new

    data = { components: {}, id: @data[:next_id] }
    @data[:next_id] += 1
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

  class Entity
    def id
      @entity_data[:id]
    end
  end
end
