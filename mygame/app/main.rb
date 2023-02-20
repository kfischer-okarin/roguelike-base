require 'smaug.rb'
require 'lib/component.rb'
require 'lib/string_utf8_chars.rb'
require 'lib/cp437_spritesheet_tileset.rb'

def tick(args)
  setup(args) if args.tick_count.zero?
  args.outputs.labels  << [640, 500, 'Hello World!', 5, 1]
  args.outputs.labels  << [640, 460, 'Go to docs/docs.html and read it!', 5, 1]
  args.outputs.labels  << [640, 420, 'Join the Discord! https://discord.dragonruby.org', 5, 1]
end

def setup(args)
  DragonSkeleton.add_to_top_level_namespace unless Object.const_defined? :Animations
end
