require 'tests/test_helpers'

def test_component_definitions(_args, assert)
  components = ComponentDefinitions.new
  components.define(:actor) do
    # ...
  end

  assert.equal! components[:actor].class, Module
  assert.equal! components.defined_types, [:actor]

  components.clear

  assert.equal! components[:actor], nil
end

def test_component_definitions_attributes(_args, assert)
  components = ComponentDefinitions.new
  components.define(:actor) do
    attribute :name
    attribute :hp, default: 100
  end

  entity_store = EntityStore.new component_definitions: components
  entity = entity_store.create_entity name: 'Player', components: [:actor]

  assert.has_attributes! entity, name: 'Player', hp: 100
end

def test_component_definitions_entity_attributes(_args, assert)
  components = ComponentDefinitions.new
  components.define(:country) do
    entity_attribute :leader
  end
  entity_store = EntityStore.new component_definitions: components

  leader = entity_store.create_entity components: []
  country = entity_store.create_entity components: [:country], leader: leader

  entity_store = EntityStore.new entity_store.data, component_definitions: components
  leader = entity_store[leader.id]
  country = entity_store[country.id]
  assert.equal! country.leader, leader
end
