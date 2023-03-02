DragonSkeleton.add_to_top_level_namespace

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

def a_tilemap
  Tilemap.new(x: 0, y: 0, cell_w: 32, cell_h: 32, grid_w: 80, grid_h: 45)
end
