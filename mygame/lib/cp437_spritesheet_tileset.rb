class CP437SpritesheetTileset
  LAYOUT = <<~CHARS.freeze
    �☺☻♥♦♣♠•◘○◙♂♀♪♫☼
    ►◄↕‼¶§▬↨↑↓→←∟↔▲▼
     !"#$%&'()*+,-./
    0123456789:;<=>?
    @ABCDEFGHIJKLMNO
    PQRSTUVWXYZ[\\]^_
    `abcdefghijklmno
    pqrstuvwxyz{|}~⌂
    ÇüéâäàåçêëèïîìÄÅ
    ÉæÆôöòûùÿÖÜ¢£¥₧ƒ
    áíóúñÑªº¿⌐¬½¼¡«»
    ░▒▓│┤╡╢╖╕╣║╗╝╜╛┐
    └┴┬├─┼╞╟╚╔╩╦╠═╬╧
    ╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀
    αßΓπΣσµτΦΘΩδ∞φε∩
    ≡±≥≤⌠⌡÷≈°∙·√ⁿ²■�
  CHARS

  def initialize(path:, w:, h:)
    @path = path
    @tile_w = w.idiv(16)
    @tile_h = h.idiv(16)
    @tiles = build_tiles
  end

  def default_tile
    { path: @path, tile_w: @tile_w, tile_h: @tile_h }
  end

  def [](tile)
    return @tiles[tile[:char]].merge(tile) if tile.is_a? Hash

    @tiles[tile]
  end

  private

  def build_tiles
    {}.tap { |result|
      lines = LAYOUT.split("\n")
      lines.each_with_index { |line, y|
        line.utf8_chars.each_with_index do |char, x|
          result[char] = { tile_x: x * @tile_w, tile_y: y * @tile_h }
        end
      }
    }
  end
end
