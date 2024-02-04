# Manages world and player
# Takes player action, applies it to the player entity, and ticks the world
class Game
  attr_accessor :player_entity

  def initialize(world:)
    @world = world
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
