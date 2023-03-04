TILES = {
  player: { char: '@' }
}

def build_tileset
  tileset = CP437SpritesheetTileset.new(path: 'sprites/Zilk-16x16.png', w: 256, h: 256)
  TILES.each do |name, attributes|
    tileset.define_tile name, attributes
  end
  tileset
end
