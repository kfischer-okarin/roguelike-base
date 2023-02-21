class EntityStore
  def initialize
    @data = { next_id: 0 }
  end

  def create_entity(components:, **attributes)
    id = @data[:next_id]
    @data[:next_id] += 1

    data = { id: id, components: {} }

    component_data = data[:components]
    components.each do |component|
      component_data[component] = Component[component].default_values.dup
    end

    entity = Entity.new(data)
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
