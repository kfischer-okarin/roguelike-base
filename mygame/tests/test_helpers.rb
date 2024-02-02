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

def build_world
  entity_store = EntityStore.new component_definitions: default_component_definitions
  World.new entity_store: entity_store, entity_types: default_entity_prototypes
end
