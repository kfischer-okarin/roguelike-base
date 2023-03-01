class Game
  attr_accessor :player_entity

  attr_reader :rendered_sprites

  def initialize(tilemap:, entity_prototypes:)
    @tilemap = tilemap
    @entity_store = EntityStore.new component_definitions: default_component_definitions
    @entity_prototypes = entity_prototypes
    @rendered_sprites = []
  end

  def create_entity(type, **attributes)
    prototype = @entity_prototypes[type].dup
    prototype[:components] += attributes[:components] if attributes[:components]
    prototype = prototype.merge(attributes.except(:components))

    @entity_store.create_entity prototype
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
