class EntityStore
  attr_reader :data

  def initialize(data = nil, component_definitions:)
    @component_definitions = component_definitions
    @data = data || { next_id: 0, entities: {} }
    @entity_objects = {}
  end

  def [](entity_id)
    unless @entity_objects.key? entity_id
      data = @data[:entities][entity_id]
      entity = Entity.new(self, data)
      data[:components].each_key do |component|
        entity.extend @component_definitions[component]
      end
      @entity_objects[entity_id] = entity
    end

    @entity_objects[entity_id]
  end

  def create_entity(components:, **attributes)
    id = @data[:next_id]
    @data[:next_id] += 1

    data = { id: id, components: {} }
    @data[:entities][id] = data

    component_data = data[:components]
    components.each do |component|
      component_data[component] = @component_definitions[component].default_values.dup
    end

    entity = self[id]
    attributes.each do |name, value|
      entity.send("#{name}=", value)
    end

    entity
  end

  class Entity
    def initialize(entity_store, data)
      @entity_store = entity_store
      @entity_data = data
      @entity_component_data = data[:components]
    end

    def id
      @entity_data[:id]
    end
  end
end
