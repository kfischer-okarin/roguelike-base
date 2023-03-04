class EntityFactory
  attr_reader :entity_store

  def initialize(entity_store:, prototypes:)
    @entity_store = entity_store
    @prototypes = prototypes
  end

  def instantiate(type, with_components: nil, **attributes)
    prototype = @prototypes[type].dup
    prototype[:components] += with_components if with_components
    prototype = prototype.merge(attributes)

    @entity_store.create_entity prototype
  end
end
