local prototype_util = {}

---@param entity LuaEntity
---@return boolean
function prototype_util.is_auto_neg_space(entity)
  return entity.name == "negative-space-auto"
    or (entity.type == "entity-ghost" and entity.ghost_name == "negative-space-auto")
end

-- Returns true if the entity prototype will colide with objects.
---@param entity LuaEntityPrototype
---@return boolean
---@nodiscard
function prototype_util.entity_is_collidable(entity)
  if entity.collision_mask_collides_with_tiles_only then
    return false
  end

  local masks = entity.collision_mask.layers
  return masks.object or masks.is_object or masks.is_lower_object
end

-- Returns true if the entity or prototype would connect with belts.
---@param entity LuaEntityPrototype|LuaEntity
---@return boolean
---@nodiscard
function prototype_util.entity_is_belt_connectable(entity)
  return entity.type == "lane-splitter"
    or entity.type == "linked-belt"
    or entity.type == "loader-1x1"
    or entity.type == "loader"
    or entity.type == "splitter"
    or entity.type == "transport-belt"
    or entity.type == "underground-belt"
end

-- Return the output or input type of an underground or linked belt, otherwise nil.
---@param entity LuaEntity
---@return BeltConnectionType?
function prototype_util.get_under_belt_type(entity)
  return (entity.type == "underground-belt" and entity.belt_to_ground_type)
    or (entity.type == "linked-belt" and entity.linked_belt_type)
    or nil
end

return prototype_util
