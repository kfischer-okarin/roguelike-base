# Accesses entity store and simulates the world
# Allow entity store to be replaced
# Entity Store might possibly be a wrapper around the actual store which allows for changing maps / areas
class World
  attr_reader :events, :last_tick_events, :entity_store

  def initialize(entity_store:, entity_types:)
    @entity_store = entity_store
    @entity_types = entity_types
    @tick = 0
    @events = []
    @entity_store.index_by(:actor)
  end

  def tick
    @last_tick_events = []
    @entity_store.entities_with_components(:actor).each do |entity|
      next unless entity.action

      send(:"perform_#{entity.action[:type]}", entity, entity.action)
      entity.action = nil
    end
    @tick += 1
    @events += @last_tick_events
  end

  def create_entity(type, with_components: nil, **attributes)
    entity_type = @entity_types[type].dup
    entity_type[:components] += with_components if with_components
    entity_type = entity_type.merge(attributes)

    @entity_store.create_entity entity_type
  end

  private

  def perform_move(entity, action)
    old_x = entity.x
    old_y = entity.y
    entity.x += action[:x]
    entity.y += action[:y]
    event_happened(
      type: :entity_moved,
      subject_id: entity.id,
      from: { x: old_x, y: old_y },
      to: { x: entity.x, y: entity.y }
    )
  end

  def event_happened(event)
    @last_tick_events << event.merge!(world_tick: @tick)
    event
  end
end
