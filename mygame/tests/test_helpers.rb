# rubocop:disable Naming/PredicateName
module GTK
  class Assert
    def has_attributes!(object, attributes)
      actual_attributes = attributes.keys.to_h { |name| [name, object.send(name)] }
      equal! actual_attributes,
             attributes,
             "Expected #{object.inspect} to have attributes #{attributes.inspect}"
    end
  end
end
# rubocop:enable Naming/PredicateName

def a_tilemap
  Tilemap.new(x: 0, y: 0, cell_w: 32, cell_h: 32, grid_w: 80, grid_h: 45)
end

class TestTileset
  def default_tile
    {}
  end

  def [](tile)
    { tile: tile }
  end
end

def a_tileset
  TestTileset.new
end

def build_world(entity_types: nil)
  entity_store = EntityStore.new component_definitions: default_component_definitions
  World.new entity_store: entity_store, entity_types: entity_types || default_entity_types
end

def build_entity_store(with_components: nil)
  component_definitions = if with_components
                            build_component_definitions(*with_components)
                          else
                            default_component_definitions
                          end
  EntityStore.new component_definitions: component_definitions
end

def build_component_definitions(*components)
  component_definitions = ComponentDefinitions.new
  components.each do |component|
    component_definitions.define component do; end
  end
  component_definitions
end

def build_empty_entity
  entity_store = build_entity_store
  entity_store.create_entity components: []
end
