class Game
  attr_accessor :player_entity

  def initialize(tilemap:, entity_prototypes:, tileset:)
    @tilemap = tilemap
    @entity_store = EntityStore.new component_definitions: default_component_definitions
    @entity_factory = EntityFactory.new entity_store: @entity_store, prototypes: entity_prototypes
    @map_renderer = MapRenderer.new(tilemap: @tilemap, entity_store: @entity_store, tileset: tileset)
    @rendered_sprites = []
  end

  def create_entity(type, with_components: nil, **attributes)
    @entity_factory.instantiate type, with_components: with_components, **attributes
  end

  def transport_player_to(map, x:, y:)
    @player_entity.place_on map, x: x, y: y
  end

  def rendered_sprites
    @map_renderer.sprites
  end

  def tick(input_actions)
    process_input input_actions
    execute_turn if @player_entity.action
    @map_renderer.render @player_entity.map, offset_x: 0, offset_y: 0
  end

  private

  def process_input(input_actions)
    return unless input_actions[:move]

    @player_entity.action = { type: :move, x: input_actions[:move][:x], y: input_actions[:move][:y] }
  end

  def execute_turn
    @player_entity.x += @player_entity.action[:x]
    @player_entity.y += @player_entity.action[:y]
    @player_entity.action = nil
  end
end
