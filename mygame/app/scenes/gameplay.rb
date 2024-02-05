module Scenes
  class Gameplay
    attr_reader :tilemap

    def initialize(game:, tilemap_size: nil)
      @game = game

      @tileset = build_tileset
      self.tilemap_size = tilemap_size || { w: 80, h: 45 }
    end

    def tilemap_size
      { w: @tilemap.grid_w, h: @tilemap.grid_h }
    end

    def tilemap_size=(size)
      @tilemap = Tilemap.new(
        x: 0, y: 0,
        cell_w: 32, cell_h: 32,
        grid_w: size[:w], grid_h: size[:h],
        tileset: build_tileset
      )
    end
  end
end
