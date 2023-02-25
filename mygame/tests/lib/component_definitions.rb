def test_component_definitions(_args, assert)
  components = ComponentDefinitions.new
  components.define(:actor) do
    # ...
  end

  assert.equal! components[:actor].class, Module
  assert.equal! components.defined_types, [:actor]

  components.clear

  assert.equal! components[:actor], nil
end
