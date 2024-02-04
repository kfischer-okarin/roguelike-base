require 'tests/test_helpers'

def test_component_definitions(_args, assert)
  components = ComponentDefinitions.new
  components.define(:actor) do
    # ...
  end

  assert.equal! components[:actor].class, ComponentDefinitions::Component
  assert.equal! components.defined_types, [:actor]

  components.clear

  assert.equal! components[:actor], nil
end

def test_component_definitions_attributes(_args, assert)
  components = ComponentDefinitions.new
  actor_component = components.define(:actor) do
    attribute :name
    attribute :hp, default: 100
  end

  entity = build_empty_entity

  actor_component.attach_to(entity, name: 'Player')

  assert.true! entity.entity_component_attached?(:actor)
  assert.has_attributes! entity, name: 'Player', hp: 100
end

def test_component_definitions_methods(_args, assert)
  components = ComponentDefinitions.new
  actor_component = components.define(:actor) do
    attribute :name
    method :title do
      "Mr. #{name}"
    end
  end

  entity = build_empty_entity

  actor_component.attach_to(entity, name: 'Player')

  assert.equal! entity.title, 'Mr. Player'
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
