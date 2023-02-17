def test_string_utf8_chars(_args, assert)
  # characters with 1 byte, 2 bytes, 3 bytes, 4 bytes
  string = 'A€⁜𑋖'

  assert.equal! string.utf8_chars, ['A', '€', '⁜', '𑋖']
end
