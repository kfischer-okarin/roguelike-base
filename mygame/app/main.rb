require 'lib/tilemap'

require 'lib/deep_dup'
require 'lib/component_definitions'
require 'lib/entity_store'
require 'lib/string_utf8_chars'
require 'lib/cp437_spritesheet_tileset'
require 'lib/map_renderer'

require 'app/components'
require 'app/entity_types'
require 'app/game'
require 'app/tileset'
require 'app/world'

def tick(args)
  setup(args) if args.tick_count.zero?
  $game.tick(process_inputs(args.inputs))
  render(args)
end

def setup(args)
  tileset = build_tileset
  args.state.tilemap = Tilemap.new(x: 0, y: -8, cell_w: 32, cell_h: 32, grid_w: 40, grid_h: 23, tileset: tileset)
  entity_store = EntityStore.new component_definitions: default_component_definitions
  world = World.new entity_store: entity_store, entity_types: default_entity_types
  $map_renderer = MapRenderer.new(tilemap: args.state.tilemap, entity_store: entity_store, tileset: tileset)
  $game = Game.new(world: world)
  $game.player_entity = world.create_entity :player
  map = world.create_entity :map, cells: Array.new(40) { Array.new(23) }
  $game.transport_player_to map, x: 20, y: 12
end

def process_inputs(gtk_inputs)
  key_down = gtk_inputs.keyboard.key_down
  input_actions = {}
  if key_down.left
    input_actions[:move] = { x: -1, y: 0 }
  elsif key_down.right
    input_actions[:move] = { x: 1, y: 0 }
  elsif key_down.down
    input_actions[:move] = { x: 0, y: -1 }
  elsif key_down.up
    input_actions[:move] = { x: 0, y: 1 }
  end
  input_actions
end

def render(args)
  args.outputs.background_color = [0, 0, 0]
  args.state.tilemap.render(args.outputs)
  $map_renderer.render $game.current_map, offset_x: 0, offset_y: 0
  args.outputs.primitives << $map_renderer.sprites
  return if $gtk.production

  args.outputs.primitives << { x: 0, y: 720, text: $gtk.current_framerate.to_i.to_s, r: 255, g: 255, b: 255 }.label!
end

$gtk.reset
