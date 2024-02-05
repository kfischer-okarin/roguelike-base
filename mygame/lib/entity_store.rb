class EntityStore
  attr_reader :data

  def initialize(data = nil, component_definitions:)
    @component_definitions = component_definitions
    @data = data || { next_id: 0, entities: {} }
    @entity_objects = initialize_entities
    @listeners = []
    @indexes = {}
  end

  def size
    @entity_objects.size
  end

  def [](entity_id)
    @entity_objects[entity_id]
  end

  def create_entity(components:, **attributes)
    data = create_new_entity_data(components)
    entity = construct_entity_from_data(data)

    attributes.each do |name, value|
      entity.send("#{name}=", value)
    end

    @entity_objects[entity.id] = entity
    @listeners.each do |listener|
      listener.entity_was_created(entity)
    end

    entity
  end

  def index_by(*components)
    components.sort!

    unless @indexes.key? components
      index = EntityIndex.new(components)
      @listeners << index
      @entity_objects.each_value do |entity|
        index.entity_was_created(entity)
      end
      @indexes[components] = index
    end

    @indexes[components]
  end

  private

  def initialize_entities
    result = {}
    @data[:entities].each do |id, entity_data|
      result[id] = construct_entity_from_data(entity_data)
    end
    result
  end

  def construct_entity_from_data(entity_data)
    entity = Entity.new(self, entity_data)
    entity_data[:components].each do |component, data|
      @component_definitions[component].attach_to(entity, **data)
    end
    entity
  end

  def create_new_entity_data(components)
    id = @data[:next_id]
    @data[:next_id] += 1

    component_data = components.to_h { |c| [c, {}] }
    @data[:entities][id] = { id: id, components: component_data }
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

    def entity_component_attached?(component)
      @entity_component_data.key? component
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

    # --- EntityStore listener interface ---
    def entity_was_created(entity)
      @entities << entity if matching? entity
    end
    # --------------------------------------

    def matching?(entity)
      @required_components.all? { |c| entity.entity_component_attached? c }
    end

    def each(&block)
      @entities.each { |entity| block.call(entity) }
    end
  end
end
