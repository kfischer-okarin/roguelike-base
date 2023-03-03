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
  $game.tick(process_inputs(args.inputs))
  render(args)
end

def setup(args)
  DragonSkeleton.add_to_top_level_namespace unless Object.const_defined? :Animations
  tileset = CP437SpritesheetTileset.new(path: 'sprites/Zilk-16x16.png', w: 256, h: 256)
  tileset.define_tile :player, { char: '@' }
  args.state.tilemap = Tilemap.new(x: 0, y: -8, cell_w: 32, cell_h: 32, grid_w: 40, grid_h: 23, tileset: tileset)
  $game = Game.new(tilemap: args.state.tilemap, entity_prototypes: default_entity_prototypes, tileset: tileset)
  $game.player_entity = $game.create_entity :player
  map = $game.create_entity :map, cells: Array.new(40) { Array.new(23) }
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
  args.outputs.primitives << $game.rendered_sprites
  return if $gtk.production

  args.outputs.primitives << { x: 0, y: 720, text: $gtk.current_framerate.to_i.to_s, r: 255, g: 255, b: 255 }.label!
end

$gtk.reset
