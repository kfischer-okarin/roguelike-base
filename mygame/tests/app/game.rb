DragonSkeleton.add_to_top_level_namespace

def test_game_create_entity(_args, assert)
  game = Game.new(
    tilemap: a_tilemap,
    entity_prototypes: {
      orc: { components: %i[map_location], x: 100, y: 100 }
    }
  )

  entity = game.create_entity :orc, x: 200

  assert.equal! entity.x, 200
  assert.equal! entity.y, 100
end

def test_game_transport_player_to(_args, assert)
  game = Game.new(
    tilemap: a_tilemap,
    entity_prototypes: default_entity_prototypes
  )
  game.player_entity = game.create_entity :player
  map = game.create_entity :map, cells: Array.new(80) { Array.new(45) }

  game.transport_player_to map, x: 20, y: 20

  assert.equal! game.player_entity.x, 20
  assert.equal! game.player_entity.y, 20
  assert.equal! game.player_entity.map, map
end

def a_tilemap
  Tilemap.new(x: 0, y: 0, cell_w: 32, cell_h: 32, grid_w: 80, grid_h: 45)
end
