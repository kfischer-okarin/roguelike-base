def test_deep_dup_array(_args, assert)
  original = [1, [2, 3], { a: 4 }]
  copy = DeepDup.dup(original)

  assert.equal! original, copy

  original << 5
  original[1] << 6
  original[2][:b] = 7
  assert.equal! copy, [1, [2, 3], { a: 4 }]
end

def test_deep_dup_hash(_args, assert)
  original = { a: 1, b: [2, 3], c: { d: 4 } }
  copy = DeepDup.dup(original)

  assert.equal! original, copy

  original[:e] = 5
  original[:b] << 6
  original[:c][:f] = 7
  assert.equal! copy, { a: 1, b: [2, 3], c: { d: 4 } }
end

def test_deep_dup_string(_args, assert)
  original = 'hello'
  copy = DeepDup.dup(original)

  assert.equal! original, copy

  original << ' world'
  assert.equal! copy, 'hello'
end

def test_raise_unless_duppable!(_args, assert)
  deep_duppable_values = [1, 1.2, 'string', :a, true, false, nil, [{ a: [3] }], { a: [1, 2] }]

  deep_duppable_values.each do |value|
    DeepDup.raise_unless_duppable!(value)
  end

  recursive_values = [[], {}, {}]
  recursive_values[0] << recursive_values[0]
  recursive_values[1][:a] = recursive_values[1]
  recursive_values[2][recursive_values[2]] = 1

  recursive_values.each do |value|
    DeepDup.raise_unless_duppable!(value)
    raise "Expected to raise an error for value #{value}"
  rescue ArgumentError => e
    assert.equal! e.message, "Value #{value} is not deep duppable (contains recursive references)"
  end

  assert.ok!
end
