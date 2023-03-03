class MapRenderer
  attr_reader :sprites

  def initialize(tilemap:, entity_store:, tileset:)
    @tilemap = tilemap
    @entity_store = entity_store
    @tileset = tileset
    @sprites = [1]
    @default_sprite = @tileset.default_tile
  end

  def render(map, offset_x:, offset_y:)
    @sprites = @entity_store.entities_with_component(:visible_on_map).map { |entity|
      sprite = @default_sprite.to_sprite(@tileset[entity.tile])
      sprite.merge! @tilemap.cell_rect({ x: entity.x - offset_x, y: entity.y - offset_y })
    }
  end
end
