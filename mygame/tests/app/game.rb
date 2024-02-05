require 'tests/test_helpers'

def test_game_create_entity(_args, assert)
  entity_store = build_entity_store
  game = Game.new(entity_store: entity_store)
  entity_count_before = entity_store.size

  entity = game.create_entity(:player)

  assert.equal! entity_store.size, entity_count_before + 1
  assert.equal! entity, entity_store[entity.id]
end

def test_game_transport_player_to(_args, assert)
  game = Game.new(entity_store: build_entity_store)
  game.player_entity = game.create_entity :player
  map = game.create_entity :map, cells: Array.new(80) { Array.new(45) }

  game.transport_player_to map, x: 20, y: 20

  assert.has_attributes! game.player_entity, x: 20, y: 20, map: map
end

def test_game_perform_player_action_movement(_args, assert)
  [
    { action: { type: :move, x: 0, y: 1 }, expected_position: { x: 20, y: 21 } },
    { action: { type: :move, x: 1, y: 0 }, expected_position: { x: 21, y: 20 } },
    { action: { type: :move, x: 0, y: -1 }, expected_position: { x: 20, y: 19 } },
    { action: { type: :move, x: -1, y: 0 }, expected_position: { x: 19, y: 20 } }
  ].each do |test_case|
    game = Game.new(entity_store: build_entity_store)
    game.player_entity = game.create_entity :player
    map = game.create_entity :map, cells: Array.new(80) { Array.new(45) }
    game.transport_player_to map, x: 20, y: 20

    game.perform_player_action test_case[:action]

    position = { x: game.player_entity.x, y: game.player_entity.y }
    assert.equal! position, test_case[:expected_position],
                  "Expected #{test_case[:expected_position]} after input #{test_case[:input_action]} " \
                  "but got #{position}"
  end
end
