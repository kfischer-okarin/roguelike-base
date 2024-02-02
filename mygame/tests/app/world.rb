require 'tests/test_helpers'

def test_world_entity_movement(_args, assert)
  entity_factory = build_entity_factory
  map = entity_factory.instantiate :map, cells: Array.new(10) { Array.new(10) }
  player1 = entity_factory.instantiate :player
  player1.place_on map, x: 5, y: 5
  # TODO: Replace with another entity
  player2 = entity_factory.instantiate :player
  player2.place_on map, x: 8, y: 8
  world = World.new entity_store: entity_factory.entity_store

  player1.action = { type: :move, x: 1, y: 0 }
  player2.action = { type: :move, x: 0, y: -1 }
  world.tick

  assert.has_attributes! player1, x: 6, y: 5, action: nil
  assert.has_attributes! player2, x: 8, y: 7, action: nil
  assert.equal! world.last_tick_events, [
    { type: :entity_moved, world_tick: 0, subject_id: player1.id, from: { x: 5, y: 5 }, to: { x: 6, y: 5 } },
    { type: :entity_moved, world_tick: 0, subject_id: player2.id, from: { x: 8, y: 8 }, to: { x: 8, y: 7 } }
  ]

  world.tick

  assert.equal! world.last_tick_events, []
  assert.equal! world.events, [
    { type: :entity_moved, world_tick: 0, subject_id: player1.id, from: { x: 5, y: 5 }, to: { x: 6, y: 5 } },
    { type: :entity_moved, world_tick: 0, subject_id: player2.id, from: { x: 8, y: 8 }, to: { x: 8, y: 7 } }
  ]
end

def test_world_create_entity(_args, assert)
  components = ComponentDefinitions.new
  components.define(:map_location) do
    attribute :x
    attribute :y
  end
  components.define(:health) do
    attribute :hp
  end
  entity_store = EntityStore.new component_definitions: components
  world = World.new entity_store: entity_store, entity_types: {
    orc: { components: %i[map_location], x: 100, y: 100 }
  }

  entity = world.create_entity :orc, with_components: %i[health], x: 200, hp: 100

  assert.has_attributes! entity, x: 200, y: 100, hp: 100
end

def test_world_create_entity_does_not_change_entity_types(_args, assert)
  components = ComponentDefinitions.new
  components.define(:map_location) do
    attribute :x
    attribute :y
  end
  components.define(:health) do
    attribute :hp
  end
  entity_store = EntityStore.new component_definitions: components
  entity_types = {
    orc: { components: %i[map_location], x: 100, y: 100 }
  }
  world = World.new entity_store: entity_store, entity_types: entity_types

  world.create_entity :orc, with_components: %i[health], x: 200, hp: 100

  assert.equal! entity_types, {
    orc: { components: %i[map_location], x: 100, y: 100 }
  }
end
