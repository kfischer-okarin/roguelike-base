class Game
  attr_accessor :player_entity

  def initialize(tilemap:, entity_prototypes:, tileset:)
    @tilemap = tilemap
    @entity_store = EntityStore.new component_definitions: default_component_definitions
    @map_renderer = MapRenderer.new(tilemap: @tilemap, entity_store: @entity_store, tileset: tileset)
    @world = World.new entity_store: @entity_store, entity_types: entity_prototypes
    @rendered_sprites = []
  end

  def create_entity(type, with_components: nil, **attributes)
    @world.create_entity type, with_components: with_components, **attributes
  end

  def transport_player_to(map, x:, y:)
    @player_entity.place_on map, x: x, y: y
  end

  def rendered_sprites
    @map_renderer.sprites
  end

  def tick(input_actions)
    process_input input_actions
    @world.tick if @player_entity.action
    @map_renderer.render @player_entity.map, offset_x: 0, offset_y: 0
  end

  private

  def process_input(input_actions)
    return unless input_actions[:move]

    @player_entity.action = { type: :move, x: input_actions[:move][:x], y: input_actions[:move][:y] }
  end
end
