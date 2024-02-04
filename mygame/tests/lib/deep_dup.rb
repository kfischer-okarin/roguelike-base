def test_deep_dup_array(_args, assert)
  original = [1, [2, 3], { a: 4 }]
  copy = deep_dup(original)

  assert.equal! original, copy

  original << 5
  original[1] << 6
  original[2][:b] = 7
  assert.equal! copy, [1, [2, 3], { a: 4 }]
end

def test_deep_dup_hash(_args, assert)
  original = { a: 1, b: [2, 3], c: { d: 4 } }
  copy = deep_dup(original)

  assert.equal! original, copy

  original[:e] = 5
  original[:b] << 6
  original[:c][:f] = 7
  assert.equal! copy, { a: 1, b: [2, 3], c: { d: 4 } }
end

def test_deep_dup_string(_args, assert)
  original = 'hello'
  copy = deep_dup(original)

  assert.equal! original, copy

  original << ' world'
  assert.equal! copy, 'hello'
end
