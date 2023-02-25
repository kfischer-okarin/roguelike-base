def test_component_define_get_clear(_args, assert)
  Component.clear_definitions
  Component.define(:actor) do
    # ...
  end

  assert.equal! Component[:actor].class, Module
  assert.equal! Component.defined_types, [:actor]

  Component.clear_definitions

  assert.equal! Component[:actor], nil
ensure
  Component.clear_definitions
end

def test_component_attributes(_args, assert)
  Component.define(:actor) do
    attribute :name
    attribute :hp, default: 100
  end

  entity_store = EntityStore.new
  entity = entity_store.create_entity name: 'Player', components: [:actor]

  assert.equal! entity.name, 'Player'
  assert.equal! entity.hp, 100
ensure
  Component.clear_definitions
end

def test_component_entity_attributes(_args, assert)
  Component.define(:country) do
    entity_attribute :leader
  end
  entity_store = EntityStore.new

  leader = entity_store.create_entity components: []
  country = entity_store.create_entity components: [:country], leader: leader

  entity_store = EntityStore.new entity_store.data
  leader = entity_store[leader.id]
  country = entity_store[country.id]
  assert.equal! country.leader, leader
ensure
  Component.clear_definitions
end
