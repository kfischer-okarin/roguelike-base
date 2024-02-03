require 'tests/test_helpers'

def test_entity_store_assigns_unique_id(_args, assert)
  entity_store = build_entity_store
  entity1 = entity_store.create_entity components: []
  entity2 = entity_store.create_entity components: []

  assert.not_equal! entity1.id, entity2.id
end

def test_entity_store_retrieve_entity_by_id(_args, assert)
  entity_store = build_entity_store
  entity = entity_store.create_entity components: []

  assert.equal! entity_store[entity.id], entity
end

def test_entity_store_index_by(_args, assert)
  entity_store = build_entity_store(with_components: %i[hero enemy elemental])
  index = entity_store.index_by(:enemy, :elemental)
  entity_store.create_entity components: %i[hero]
  entity_store.create_entity components: %i[hero elemental]
  entity_store.create_entity components: %i[enemy]
  elemental_enemy1 = entity_store.create_entity components: %i[enemy elemental]
  elemental_enemy2 = entity_store.create_entity components: %i[enemy elemental]

  assert.equal! index.is_a?(Enumerable), true, "Expected index to be an Enumerable but got #{index.class}"
  assert.equal! index.to_a, [elemental_enemy1, elemental_enemy2]
end

def test_entity_store_index_by_with_existing_components(_args, assert)
  entity_store = build_entity_store(with_components: %i[hero enemy elemental])
  entity_store.create_entity components: %i[hero]
  entity_store.create_entity components: %i[hero elemental]
  entity_store.create_entity components: %i[enemy]
  elemental_enemy1 = entity_store.create_entity components: %i[enemy elemental]
  elemental_enemy2 = entity_store.create_entity components: %i[enemy elemental]
  index = entity_store.index_by(:enemy, :elemental)

  assert.equal! index.to_a, [elemental_enemy1, elemental_enemy2]
end

def test_entity_store_can_be_initialized_from_serialized_data(_args, assert)
  components = ComponentDefinitions.new
  components.define(:enemy) do
    attribute :difficulty, default: 1
  end
  entity_store = EntityStore.new component_definitions: components
  entity = entity_store.create_entity components: [:enemy], difficulty: 3

  entity_store = EntityStore.new entity_store.data, component_definitions: components

  assert.equal! entity_store[entity.id].difficulty, entity.difficulty
end

def test_entity_store_from_serialized_data_indexes_existing_data_correctly(_args, assert)
  component_definitions = build_component_definitions(:enemy)
  entity_store = EntityStore.new component_definitions: component_definitions
  entity = entity_store.create_entity components: [:enemy]
  entity_store = EntityStore.new entity_store.data, component_definitions: component_definitions
  index = entity_store.index_by(:enemy)

  assert.equal! index.map(&:id), [entity.id]
end
