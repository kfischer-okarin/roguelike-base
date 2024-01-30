require 'tests/test_helpers'

def test_game_create_entity(_args, assert)
  game = Game.new(
    tilemap: a_tilemap,
    tileset: a_tileset,
    entity_prototypes: {
      orc: { components: %i[map_location], x: 100, y: 100 }
    }
  )

  entity = game.create_entity :orc, x: 200

  assert.has_attributes! entity, x: 200, y: 100
end

def test_game_transport_player_to(_args, assert)
  game = Game.new(tilemap: a_tilemap, tileset: a_tileset, entity_prototypes: default_entity_prototypes)
  game.player_entity = game.create_entity :player
  map = game.create_entity :map, cells: Array.new(80) { Array.new(45) }

  game.transport_player_to map, x: 20, y: 20

  assert.has_attributes! game.player_entity, x: 20, y: 20, map: map
end

def test_game_tick_movement(_args, assert)
  [
    { input_action: { move: { x: 0, y: 1 } }, expected_position: { x: 20, y: 21 } },
    { input_action: { move: { x: 0, y: -1 } }, expected_position: { x: 20, y: 19 } },
    { input_action: { move: { x: 1, y: 0 } }, expected_position: { x: 21, y: 20 } },
    { input_action: { move: { x: -1, y: 0 } }, expected_position: { x: 19, y: 20 } }
  ].each do |test_case|
    game = Game.new(tilemap: a_tilemap, tileset: a_tileset, entity_prototypes: default_entity_prototypes)
    game.player_entity = game.create_entity :player
    map = game.create_entity :map, cells: Array.new(80) { Array.new(45) }
    game.transport_player_to map, x: 20, y: 20

    game.tick test_case[:input_action]

    position = { x: game.player_entity.x, y: game.player_entity.y }
    assert.equal! position, test_case[:expected_position],
                  "Expected #{test_case[:expected_position]} after input #{test_case[:input_action]} but got #{position}"
  end
end
