def test_component_define_get_clear(_args, assert)
  Component.clear_definitions
  Component.define(:actor) do
    # ...
  end

  assert.equal! Component[:actor].class, Module
  assert.equal! Component.defined_types, [:actor]

  Component.clear_definitions

  assert.equal! Component[:actor], nil
end

def test_component_attributes(_args, assert)
  Component.clear_definitions
  Component.define(:actor) do
    attribute :name
    attribute :hp, default: 100
  end

  entity_store = EntityStore.new
  entity = entity_store.create_entity name: 'Player', components: [:actor]

  assert.equal! entity.name, 'Player'
  assert.equal! entity.hp, 100
end
