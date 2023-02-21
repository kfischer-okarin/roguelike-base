class EntityStore
  attr_reader :data

  def initialize(data = nil)
    @data = data || { next_id: 0, entities: {} }
    @entity_objects = {}
  end

  def [](entity_id)
    @entity_objects[entity_id] ||= Entity.new(@data[:entities][entity_id])
  end

  def create_entity(components:, **attributes)
    id = @data[:next_id]
    @data[:next_id] += 1

    data = { id: id, components: {} }
    @data[:entities][id] = data

    component_data = data[:components]
    components.each do |component|
      component_data[component] = Component[component].default_values.dup
    end

    entity = self[id]
    attributes.each do |name, value|
      entity.send("#{name}=", value)
    end

    entity
  end

  class Entity
    def initialize(data)
      @entity_data = data
      @entity_component_data = data[:components]
      @entity_component_data.each_key do |component|
        extend Component[component]
      end
    end

    def id
      @entity_data[:id]
    end
  end
end
