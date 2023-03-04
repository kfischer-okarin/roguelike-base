class World
  def initialize(entity_store:)
    @entity_store = entity_store
  end

  def tick
    @entity_store.entities_with_component(:actor).each do |entity|
      next unless entity.action

      send(:"perform_#{entity.action[:type]}", entity, entity.action)
      entity.action = nil
    end
  end

  private

  def perform_move(entity, action)
    entity.x += action[:x]
    entity.y += action[:y]
  end
end
