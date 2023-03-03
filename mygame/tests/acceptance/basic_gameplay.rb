require 'tests/test_helpers.rb'

def test_basic_gameplay(args, assert)
  GameTest.new(args, assert) do
    with_map <<~MAP
      .........
      .........
      ....@....
      .........
      .........
    MAP

    act :move_right

    assert_map_view <<~MAP
      .........
      .........
      .....@...
      .........
      .........
    MAP
  end
end

class GameTest
  def initialize(args, assert, &block)
    @args = args
    @assert = assert
    @tileset = TestTileset.new
    @tilemap = build_tilemap(80, 45)
    instance_eval(&block)
  end

  def with_map(map_string)
    lines = map_string.split("\n").reverse
    map_w = lines[0].size
    map_h = lines.size
    map_tiles = Array.new(map_w) { Array.new(map_h) }
    entity_positions = {}
    lines.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        map_tiles[x][y] = nil
        next if char == '.'

        entity_positions[char] ||= []
        entity_positions[char] << { x: x, y: y }
      end
    end

    @tilemap = build_tilemap(map_w, map_h)
    @game = nil
    map = game.create_entity :map, cells: map_tiles
    game.player_entity = game.create_entity :player
    game.transport_player_to map, **entity_positions['@'].first
  end

  def act(*actions)
    actions.each do |action|
      @game.tick convert_action(action)
    end
  end

  def assert_map_view(expected_map_view)
    map_tiles = (0...@tilemap.grid_h).map { |y|
      (0...@tilemap.grid_w).map { |x|
        @tilemap[x, y].tile || '.'
      }
    }
    @game.rendered_sprites.each do |sprite|
      sprite_x, sprite_y = @tilemap.to_grid_coordinates(sprite)
      map_tiles[sprite_x][sprite_y] = sprite[:char]
    end
    actual_map_view = map_tiles.map { |row_chars|
      "#{row_chars.join}\n"
    }.reverse.join

    @assert.equal! actual_map_view, expected_map_view
  end

  private

  def build_tilemap(w, h)
    Tilemap.new(x: 0, y: 0, cell_w: 32, cell_h: 32, grid_w: w, grid_h: h, tileset: @tileset)
  end

  def game
    @game ||= Game.new(
      tilemap: @tilemap,
      tileset: @tileset,
      entity_prototypes: default_entity_prototypes
    )
  end

  def convert_action(action)
    case action
    when :move_right
      { move: { x: 1, y: 0 } }
    end
  end
end
