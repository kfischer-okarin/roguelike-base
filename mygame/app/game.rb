# Manages world and player
# Takes player action, applies it to the player entity, and ticks the world
class Game
  attr_accessor :player_entity

  def initialize(entity_store:)
    @world = World.new entity_store: entity_store, entity_types: default_entity_types
  end

  def create_entity(type, with_components: nil, **attributes)
    @world.create_entity type, with_components: with_components, **attributes
  end

  def transport_player_to(map, x:, y:)
    @player_entity.place_on map, x: x, y: y
  end

  def current_map
    @player_entity.map
  end

  def perform_player_action(action)
    @player_entity.action = action
    @world.tick
  end
end
