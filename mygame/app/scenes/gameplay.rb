module Scenes
  class Gameplay
    attr_reader :tilemap

    def initialize(game:, tilemap_size: nil)
      @game = game

      @tileset = build_tileset
      self.tilemap_size = tilemap_size || { w: 80, h: 45 }
    end

    def tick(input_actions)
      player_action = player_action(input_actions)
      @game.perform_player_action(player_action) if player_action

      @map_renderer.render @game.current_map, offset_x: 0, offset_y: 0
    end

    def sprites
      @map_renderer.sprites
    end

    def tilemap_size
      { w: @tilemap.grid_w, h: @tilemap.grid_h }
    end

    def tilemap_size=(size)
      @tilemap = Tilemap.new(
        x: 0, y: 0,
        cell_w: 32, cell_h: 32,
        grid_w: size[:w], grid_h: size[:h],
        tileset: @tileset
      )
      @map_renderer = MapRenderer.new(tilemap: @tilemap, entity_store: @game.entity_store, tileset: @tileset)
    end

    private

    def player_action(input_actions)
      return unless input_actions[:move]

      { type: :move, x: input_actions[:move][:x], y: input_actions[:move][:y] }
    end
  end
end
