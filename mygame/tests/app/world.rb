require 'tests/test_helpers.rb'

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
end
