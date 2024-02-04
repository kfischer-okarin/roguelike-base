def default_entity_types
  {
    player: {
      components: %i[map_location visible_on_map actor],
      tile: :player
    },
    map: {
      components: %i[grid]
    }
  }
end
