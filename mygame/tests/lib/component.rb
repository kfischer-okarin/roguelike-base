def test_component_define_get_clear(_args, assert)
  Component.clear_definitions
  Component.define(:actor) do
    # ...
  end

  assert.equal! Component[:actor].class, Module
  assert.equal! Component.defined_types, [:actor]

  Component.clear_definitions

  assert.equal! Component[:actor], nil
end
