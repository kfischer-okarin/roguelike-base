def test_entity_store_assigns_unique_id(_args, assert)
  entity_store = EntityStore.new
  entity1 = entity_store.create_entity components: []
  entity2 = entity_store.create_entity components: []

  assert.not_equal! entity1.id, entity2.id
end

def test_entity_store_retrieve_entity_by_id(_args, assert)
  entity_store = EntityStore.new
  entity = entity_store.create_entity components: []

  assert.equal! entity_store[entity.id], entity
end
