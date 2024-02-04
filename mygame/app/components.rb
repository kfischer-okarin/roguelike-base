def default_component_definitions
  components = ComponentDefinitions.new

  components.define :map_location do
    entity_attribute :map
    attribute :x
    attribute :y

    method :place_on do |map, x:, y:|
      self.map = map
      self.x = x
      self.y = y
    end
  end

  components.define :map do
    attribute :cells

    method :w do
      cells.size
    end

    method :h do
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
