local prototype_util = {}

-- Return the type of the Entity, resolving ghosts.
---@param entity LuaEntity
---@return string
function prototype_util.entity_type(entity)
  return entity.type == "entity-ghost" and entity.ghost_type or entity.type
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
  local type = entity.object_name == "LuaEntity" and prototype_util.entity_type(entity) or entity.type
  return type == "lane-splitter"
    or type == "linked-belt"
    or type == "loader-1x1"
    or type == "loader"
    or type == "splitter"
    or type == "transport-belt"
    or type == "underground-belt"
end

-- Return the output or input type of an underground or linked belt, otherwise nil.
---@param entity LuaEntity
---@return BeltConnectionType?
function prototype_util.get_under_belt_type(entity)
  local type = prototype_util.entity_type(entity)
  return (type == "underground-belt" and entity.belt_to_ground_type)
    or (type == "linked-belt" and entity.linked_belt_type)
    or nil
end

return prototype_util
