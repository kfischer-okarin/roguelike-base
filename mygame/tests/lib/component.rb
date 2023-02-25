def test_component_attributes(_args, assert)
  components = ComponentDefinitions.new
  components.define(:actor) do
    attribute :name
    attribute :hp, default: 100
  end

  entity_store = EntityStore.new component_definitions: components
  entity = entity_store.create_entity name: 'Player', components: [:actor]

  assert.equal! entity.name, 'Player'
  assert.equal! entity.hp, 100
end

def test_component_entity_attributes(_args, assert)
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
