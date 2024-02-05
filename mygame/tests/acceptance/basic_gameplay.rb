require 'tests/test_helpers'

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
    @entity_store = build_entity_store
    @game = Game.new(entity_store: @entity_store)
    @tileset = build_tileset
    @gameplay_scene = Scenes::Gameplay.new(game: @game)
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

    @gameplay_scene.tilemap_size = { w: map_w, h: map_h }
    map = @game.create_entity :map, cells: map_tiles
    @game.player_entity = @game.create_entity :player
    @game.transport_player_to map, **entity_positions['@'].first
  end

  def act(*actions)
    actions.each do |action|
      @gameplay_scene.tick(convert_action(action))
    end
  end

  def assert_map_view(expected_map_view)
    map_tiles = (0...tilemap.grid_h).map { |y|
      (0...tilemap.grid_w).map { |x|
        tilemap[x, y].tile || '.'
      }
    }
    map_renderer = MapRenderer.new(tilemap: tilemap, entity_store: @entity_store, tileset: @tileset)
    map_renderer.render @game.current_map, offset_x: 0, offset_y: 0
    map_renderer.sprites.each do |sprite|
      grid_coordinates = tilemap.to_grid_coordinates(sprite)
      map_tiles[grid_coordinates[:y]][grid_coordinates[:x]] = sprite[:char]
    end
    actual_map_view = map_tiles.map { |row_chars|
      "#{row_chars.join}\n"
    }.reverse.join

    @assert.equal! actual_map_view, expected_map_view
  end

  private

  def tilemap
    @gameplay_scene.tilemap
  end

  def convert_action(action)
    case action
    when :move_right
      { move: { x: 1, y: 0 } }
    end
  end
end
