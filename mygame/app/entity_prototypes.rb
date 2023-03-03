def default_entity_prototypes
  {
    player: {
      components: %i[map_location visible_on_map],
      tile: :player
    },
    map: {
      components: %i[map]
    }
  }
end
