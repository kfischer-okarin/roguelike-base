require 'tests/test_helpers.rb'

def test_entity_factory_instantiate(_args, assert)
  components = ComponentDefinitions.new
  components.define(:map_location) do
    attribute :x
    attribute :y
  end
  components.define(:health) do
    attribute :hp
  end
  entity_store = EntityStore.new component_definitions: components
  factory = EntityFactory.new entity_store: entity_store, prototypes: {
    orc: { components: %i[map_location], x: 100, y: 100 }
  }

  entity = factory.instantiate :orc, with_components: %i[health], x: 200, hp: 100

  assert.has_attributes! entity, x: 200, y: 100, hp: 100
end
