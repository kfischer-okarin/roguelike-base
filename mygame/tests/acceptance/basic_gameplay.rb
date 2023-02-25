DragonSkeleton.add_to_top_level_namespace

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
    @player = game.create_entity :player, map: map, **entity_positions['@'].first
  end

  def act(*actions)
    actions.each do |action|
      @game.tick convert_action(action)
    end
  end

  def assert_map_view(expected_map_view)
    actual_map_view = (0...@tilemap.grid_h).map { |y|
      row = (0...@tilemap.grid_w).map { |x|
        @tilemap[x, y].tile || '.'
      }.join

      "#{row}\n"
    }.reverse.join

    @assert.equal! actual_map_view, expected_map_view
  end

  private

  def build_tilemap(w, h)
    Tilemap.new(x: 0, y: 0, cell_w: 32, cell_h: 32, grid_w: w, grid_h: h)
  end

  def game
    @game ||= Game.new(tilemap: @tilemap)
  end

  def convert_action(action)
    case action
    when :move_right
      { move: { x: 1, y: 0 } }
    end
  end
end
