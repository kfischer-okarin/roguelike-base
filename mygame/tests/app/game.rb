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

def a_tilemap
  Tilemap.new(x: 0, y: 0, cell_w: 32, cell_h: 32, grid_w: 80, grid_h: 45)
end
