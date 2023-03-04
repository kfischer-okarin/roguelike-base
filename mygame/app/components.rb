def default_component_definitions
  components = ComponentDefinitions.new

  components.define :map_location do
    entity_attribute :map
    attribute :x
    attribute :y

    def place_on(map, x:, y:)
      self.map = map
      self.x = x
      self.y = y
    end
  end

  components.define :map do
    attribute :cells

    def w
      cells.size
    end

    def h
      cells[0].size
    end
  end

  components.define :visible_on_map do
    attribute :tile
  end

  components.define :actor do
    attribute :action
  end

  components
end
