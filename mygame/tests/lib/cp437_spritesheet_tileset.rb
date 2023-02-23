def test_cp437_spritesheet_tileset_default_tile(_args, assert)
  tileset = CP437SpritesheetTileset.new(path: 'tileset.png', w: 512, h: 512)

  assert.equal! tileset.default_tile, { path: 'tileset.png', tile_w: 32, tile_h: 32 }
end

def test_cp437_spritesheet_tileset_tile(_args, assert)
  tileset = CP437SpritesheetTileset.new(path: 'tileset.png', w: 512, h: 512)

  assert.equal! tileset['A'], { tile_x: 32, tile_y: 128 }
end

def test_cp437_spritesheet_tileset_tile_with_color(_args, assert)
  tileset = CP437SpritesheetTileset.new(path: 'tileset.png', w: 512, h: 512)

  assert.equal! tileset[{ char: 'A', r: 200, g: 100, b: 100 }],
                { tile_x: 32, tile_y: 128, char: 'A', r: 200, g: 100, b: 100 }
end

def test_cp437_spritesheet_tileset_defined_tile(_args, assert)
  tileset = CP437SpritesheetTileset.new(path: 'tileset.png', w: 512, h: 512)
  tileset.define_tile :player, { char: '@', r: 128, g: 0, b: 128 }

  assert.equal! tileset[:player],
                { tile_x: 0, tile_y: 128, char: '@', r: 128, g: 0, b: 128 }
end
