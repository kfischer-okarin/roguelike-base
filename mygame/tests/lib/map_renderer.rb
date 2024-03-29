require 'tests/test_helpers'

def test_map_renderer_render(_args, assert)
  world = build_world
  map = world.create_entity :map, cells: Array.new(20) { Array.new(20) }
  world.create_entity :player, map: map, x: 5, y: 5
  tilemap = Tilemap.new(x: 0, y: 0, cell_w: 32, cell_h: 32, grid_w: 10, grid_h: 10)
  renderer = MapRenderer.new(tilemap: tilemap, entity_store: world.entity_store, tileset: TestTileset.new)

  renderer.render(map, offset_x: 5, offset_y: 5)

  assert.has_attributes! renderer.sprites, length: 1
  sprite = renderer.sprites[0]
  assert.equal! sprite, tilemap.cell_rect({ x: 0, y: 0 }).sprite!(tile: :player)
end
