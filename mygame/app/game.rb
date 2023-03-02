class Game
  attr_accessor :player_entity

  attr_reader :rendered_sprites

  def initialize(tilemap:, entity_prototypes:)
    @tilemap = tilemap
    @entity_store = EntityStore.new component_definitions: default_component_definitions
    @entity_factory = EntityFactory.new entity_store: @entity_store, prototypes: entity_prototypes
    @rendered_sprites = []
  end

  def create_entity(type, with_components: nil, **attributes)
    @entity_factory.instantiate type, with_components: with_components, **attributes
  end

  def transport_player_to(map, x:, y:)
    @player_entity.x = x
    @player_entity.y = y
    @player_entity.map = map
  end

  def tick(input_actions)
    if input_actions[:move]
      @player_entity.x += input_actions[:move][:x]
      @player_entity.y += input_actions[:move][:y]
    end
  end
end
