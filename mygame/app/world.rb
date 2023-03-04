class World
  attr_reader :events, :last_tick_events

  def initialize(entity_store:)
    @entity_store = entity_store
    @tick = 0
    @events = []
  end

  def tick
    @last_tick_events = []
    @entity_store.entities_with_component(:actor).each do |entity|
      next unless entity.action

      send(:"perform_#{entity.action[:type]}", entity, entity.action)
      entity.action = nil
    end
    @tick += 1
    @events += @last_tick_events
  end

  private

  def perform_move(entity, action)
    old_x = entity.x
    old_y = entity.y
    entity.x += action[:x]
    entity.y += action[:y]
    @last_tick_events << {
      type: :entity_moved,
      world_tick: @tick,
      subject_id: entity.id,
      from: { x: old_x, y: old_y },
      to: { x: entity.x, y: entity.y }
    }
  end
end
