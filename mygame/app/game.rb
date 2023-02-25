class Game
  attr_accessor :player_entity

  def initialize(tilemap:, entity_prototypes:)
    @tilemap = tilemap
    @entity_store = EntityStore.new component_definitions: default_component_definitions
    @entity_prototypes = entity_prototypes
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
  end
end
