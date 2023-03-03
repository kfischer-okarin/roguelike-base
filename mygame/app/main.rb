require 'smaug.rb'

require 'lib/component.rb'
require 'lib/component_definitions.rb'
require 'lib/entity_factory.rb'
require 'lib/entity_store.rb'
require 'lib/string_utf8_chars.rb'
require 'lib/cp437_spritesheet_tileset.rb'
require 'lib/map_renderer.rb'

require 'app/components.rb'
require 'app/entity_prototypes.rb'
require 'app/game.rb'

def tick(args)
  setup(args) if args.tick_count.zero?
  args.outputs.labels  << [640, 500, 'Hello World!', 5, 1]
  args.outputs.labels  << [640, 460, 'Go to docs/docs.html and read it!', 5, 1]
  args.outputs.labels  << [640, 420, 'Join the Discord! https://discord.dragonruby.org', 5, 1]
end

def setup(args)
  DragonSkeleton.add_to_top_level_namespace unless Object.const_defined? :Animations
  $entity_store = EntityStore.new component_definitions: default_component_definitions
  args.state.entities = $entity_store.data
  map = $entity_store.create_entity components: %i[map], cells: Array.new(40) { Array.new(23) }
  $entity_store.create_entity components: %i[map_location], map: map, x: 20, y: 12
end

$gtk.reset
