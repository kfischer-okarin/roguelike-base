class EntityStore
  attr_reader :data

  def initialize(data = nil, component_definitions:)
    @component_definitions = component_definitions
    @data = data || { next_id: 0, entities: {} }
    @entity_objects = {}
    @listeners = []
  end

  def [](entity_id)
    unless @entity_objects.key? entity_id
      data = @data[:entities][entity_id]
      entity = construct_entity(data)
      @listeners.each { |l| l.entity_was_created(entity) }
      @entity_objects[entity_id] = entity
    end

    @entity_objects[entity_id]
  end

  def create_entity(components:, **attributes)
    data = create_new_entity_data(components)

    entity = self[data[:id]]
    attributes.each do |name, value|
      entity.send("#{name}=", value)
    end

    entity
  end

  def index_by(*components)
    index = EntityIndex.new(components)
    @listeners << index
    @entity_objects.each_value do |entity|
      index.entity_was_created(entity)
    end
    index
  end

  private

  def create_new_entity_data(components)
    id = @data[:next_id]
    @data[:next_id] += 1

    data = { id: id, components: {} }
    @data[:entities][id] = data

    component_data = data[:components]
    components.each do |component|
      component_data[component] = @component_definitions[component].default_values.dup
    end

    data
  end

  def construct_entity(data)
    entity = Entity.new(self, data)
    data[:components].each_key do |component|
      entity.extend @component_definitions[component]
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

    def components
      @entity_component_data.keys
    end

    def to_s
      "Entity #{id} (#{@entity_component_data.keys.map(&:to_s).join(', ')})"
    end

    def inspect
      "Entity(#{@entity_data.inspect})"
    end
  end

  class EntityIndex
    include Enumerable

    def initialize(required_components)
      @required_components = required_components
      @entities = []
    end

    def entity_was_created(entity)
      @entities << entity if matching? entity
    end

    def matching?(entity)
      @required_components.all? { |c| entity.components.include? c }
    end

    def each(&block)
      @entities.each { |entity| block.call(entity) }
    end
  end
end
