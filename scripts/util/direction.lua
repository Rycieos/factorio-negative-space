local direction_util = {}

-- Rotate a direction by 90 degrees per point
---@param direction defines.direction
---@param amount integer Between -4 and 4
---@return defines.direction
function direction_util.rotate(direction, amount)
  return (direction + amount * 4 + 16) % 16
end

---@type {[defines.direction]: MapPosition}
direction_util.offsets = {
  [defines.direction.north] = { x = 0, y = -1 },
  [defines.direction.east] = { x = 1, y = 0 },
  [defines.direction.south] = { x = 0, y = 1 },
  [defines.direction.west] = { x = -1, y = 0 },
  [defines.direction.northeast] = { x = 1, y = -1 },
  [defines.direction.southeast] = { x = 1, y = 1 },
  [defines.direction.southwest] = { x = -1, y = 1 },
  [defines.direction.northwest] = { x = -1, y = -1 },
}

---@param offset MapPosition
---@return defines.direction?
function direction_util.get_direction_from_offset(offset)
  if offset.x == 0 and offset.y == -1 then
    return defines.direction.north
  elseif offset.x == 1 and offset.y == 0 then
    return defines.direction.east
  elseif offset.x == 0 and offset.y == 1 then
    return defines.direction.south
  elseif offset.x == -1 and offset.y == 0 then
    return defines.direction.west
  end
end

-- While not well documented, both TransportBeltConectable and
-- PipeConnectionDefinition can only connect on orthoginal directions.
-- Also not documented, but splitters MUST be 2x1, and transport-belts,
-- underground-belts, linked-belts, and lane-splitters MUST be 1x1.
-- This means that while collision can be custom, the connecting of belts is
-- static in the engine, and we can safely assume which sides are connectable.

-- All facing north, and therefore all will connect to the north, except for
-- underground-belt (input), which will connect to the south, despite "facing"
-- north.
---@type {[string]: defines.direction[]}
direction_util.directions = {
  ["transport-belt"] = {
    defines.direction.east,
    defines.direction.south,
    defines.direction.west,
  },
  ["lane-splitter"] = {
    defines.direction.south,
  },
  ["splitter"] = {
    defines.direction.south,
  },
  ["underground-belt"] = {
    defines.direction.east,
    defines.direction.west,
  },
  ["loader-1x1"] = {},
  ["loader"] = {},
  ["linked-belt"] = {},
}

return direction_util
