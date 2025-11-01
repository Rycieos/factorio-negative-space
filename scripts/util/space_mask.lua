local direction_util = require("scripts.util.direction")
local math2d = require("math2d")
local prototype_util = require("scripts.util.prototype")

local space_mask = {}

---@alias SpaceMask SpaceMaskEnum|uint32
---@enum SpaceMaskEnum
local SpaceMask = {
  blocked = 2 ^ 0,
  belt = 2 ^ 1,
  fluid = 2 ^ 2,
  belt_to_north = 2 ^ 3,
  belt_to_east = 2 ^ 4,
  belt_to_south = 2 ^ 5,
  belt_to_west = 2 ^ 6,
  belt_from_north = 2 ^ 7,
  belt_from_east = 2 ^ 8,
  belt_from_south = 2 ^ 9,
  belt_from_west = 2 ^ 10,
  fluid_to_north = 2 ^ 11,
  fluid_to_east = 2 ^ 12,
  fluid_to_south = 2 ^ 13,
  fluid_to_west = 2 ^ 14,
  fluid_from_north = 2 ^ 15,
  fluid_from_east = 2 ^ 16,
  fluid_from_south = 2 ^ 17,
  fluid_from_west = 2 ^ 18,
}
space_mask.SpaceMask = SpaceMask

-- Returns a copy of `n` with the bits `field` to `field + width - 1` replaced by the value `v` .
-- Overridden to fix incorrect return type.
---@param n integer
---@param v integer
---@param field  integer
---@param width? integer
---@return integer
---@nodiscard
local function bit_replace(n, v, field, width)
  ---@diagnostic disable-next-line: return-type-mismatch
  return bit32.replace(n, v, field, width)
end

-- Rotate the direction of a SpaceMask.
---@param mask SpaceMask
---@param rotation integer
---@return SpaceMask
function space_mask.rotate_mask(mask, rotation)
  for i = 1, (rotation + 4) % 4 do
    local belt_to_lower = bit32.extract(mask, 3, 3)
    local belt_to_top = bit32.extract(mask, 6)
    local belt_from_lower = bit32.extract(mask, 7, 3)
    local belt_from_top = bit32.extract(mask, 10)
    local fluid_to_lower = bit32.extract(mask, 11, 3)
    local fluid_to_top = bit32.extract(mask, 14)
    local fluid_from_lower = bit32.extract(mask, 15, 3)
    local fluid_from_top = bit32.extract(mask, 18)
    mask = bit_replace(mask, belt_to_lower, 4, 3)
    mask = bit_replace(mask, belt_to_top, 3)
    mask = bit_replace(mask, belt_from_lower, 8, 3)
    mask = bit_replace(mask, belt_from_top, 7)
    mask = bit_replace(mask, fluid_to_lower, 12, 3)
    mask = bit_replace(mask, fluid_to_top, 11)
    mask = bit_replace(mask, fluid_from_lower, 16, 3)
    mask = bit_replace(mask, fluid_from_top, 15)
  end
  return mask
end

-- Mirror a mask over the horizonal axis.
---@param mask SpaceMask
---@return SpaceMask
function space_mask.flip_mask(mask)
  local belt_to_east = bit32.extract(mask, 4)
  local belt_to_west = bit32.extract(mask, 6)
  local belt_from_east = bit32.extract(mask, 8)
  local belt_from_west = bit32.extract(mask, 10)
  local fluid_to_east = bit32.extract(mask, 12)
  local fluid_to_west = bit32.extract(mask, 14)
  local fluid_from_east = bit32.extract(mask, 16)
  local fluid_from_west = bit32.extract(mask, 18)
  mask = bit_replace(mask, belt_to_east, 6)
  mask = bit_replace(mask, belt_to_west, 4)
  mask = bit_replace(mask, belt_from_east, 10)
  mask = bit_replace(mask, belt_from_west, 8)
  mask = bit_replace(mask, fluid_to_east, 14)
  mask = bit_replace(mask, fluid_to_west, 12)
  mask = bit_replace(mask, fluid_from_east, 18)
  mask = bit_replace(mask, fluid_from_west, 16)
  return mask
end

-- Log a SpaceMask for debugging purposes.
---@param mask SpaceMask
function space_mask.log(mask)
  local oct2bin = {
    ["0"] = "000",
    ["1"] = "001",
    ["2"] = "010",
    ["3"] = "011",
    ["4"] = "100",
    ["5"] = "101",
    ["6"] = "110",
    ["7"] = "111",
  }

  log("FF  FT  BF  BT  FBX")
  log("WSENWSENWSENWSEN")
  local s = string.format("%.7o", mask)
  s = s:gsub(".", function(a)
    return oct2bin[a]
  end)
  log(string.sub(s, 3))
end

-- Belt mask for entities adjacent facing a direction that can be connected to.
local to_belts = {
  [defines.direction.north] = SpaceMask.belt_to_south + SpaceMask.belt,
  [defines.direction.east] = SpaceMask.belt_to_west + SpaceMask.belt,
  [defines.direction.south] = SpaceMask.belt_to_north + SpaceMask.belt,
  [defines.direction.west] = SpaceMask.belt_to_east + SpaceMask.belt,
}
-- Belt mask for entities adjacent facing a direction that will connect.
local from_belts = {
  [defines.direction.north] = SpaceMask.belt_from_south + SpaceMask.belt_to_south + SpaceMask.belt,
  [defines.direction.east] = SpaceMask.belt_from_west + SpaceMask.belt_to_west + SpaceMask.belt,
  [defines.direction.south] = SpaceMask.belt_from_north + SpaceMask.belt_to_north + SpaceMask.belt,
  [defines.direction.west] = SpaceMask.belt_from_east + SpaceMask.belt_to_east + SpaceMask.belt,
}
-- Belt masks for entities in a space facing a direction that will connect.
local match_to_belts = {
  [defines.direction.north] = SpaceMask.belt_to_north,
  [defines.direction.east] = SpaceMask.belt_to_east,
  [defines.direction.south] = SpaceMask.belt_to_south,
  [defines.direction.west] = SpaceMask.belt_to_west,
}
-- Belt masks for entities in a space facing a direction that can be connected to.
local match_from_belts = {
  [defines.direction.north] = SpaceMask.belt_from_north,
  [defines.direction.east] = SpaceMask.belt_from_east,
  [defines.direction.south] = SpaceMask.belt_from_south,
  [defines.direction.west] = SpaceMask.belt_from_west,
}
space_mask.to_fluids = {
  [defines.direction.north] = SpaceMask.fluid_to_south + SpaceMask.fluid,
  [defines.direction.east] = SpaceMask.fluid_to_west + SpaceMask.fluid,
  [defines.direction.south] = SpaceMask.fluid_to_north + SpaceMask.fluid,
  [defines.direction.west] = SpaceMask.fluid_to_east + SpaceMask.fluid,
}
space_mask.from_fluids = {
  [defines.direction.north] = SpaceMask.fluid_from_south + SpaceMask.fluid,
  [defines.direction.east] = SpaceMask.fluid_from_west + SpaceMask.fluid,
  [defines.direction.south] = SpaceMask.fluid_from_north + SpaceMask.fluid,
  [defines.direction.west] = SpaceMask.fluid_from_east + SpaceMask.fluid,
}
space_mask.match_to_fluids = {
  [defines.direction.north] = SpaceMask.fluid_to_north,
  [defines.direction.east] = SpaceMask.fluid_to_east,
  [defines.direction.south] = SpaceMask.fluid_to_south,
  [defines.direction.west] = SpaceMask.fluid_to_west,
}
space_mask.match_from_fluids = {
  [defines.direction.north] = SpaceMask.fluid_from_north,
  [defines.direction.east] = SpaceMask.fluid_from_east,
  [defines.direction.south] = SpaceMask.fluid_from_south,
  [defines.direction.west] = SpaceMask.fluid_from_west,
}

-- Get all connecting points around a TransportBeltConnectable.
---@param type string
---@param direction defines.direction
---@param belt_type? BeltConnectionType
---@return {[MapPosition]: SpaceMaskEnum}
function space_mask.generate_transport_belt_points(type, direction, belt_type)
  if belt_type == "input" then
    direction = direction_util.rotate(direction, 2)
  end
  local rotation = direction / 4
  local points = {
    -- From direction implies to the same direction.
    [direction_util.offsets[direction]] = belt_type ~= "input" and from_belts[direction] or to_belts[direction],
  }

  for _, other_direction in pairs(direction_util.directions[type]) do
    other_direction = direction_util.rotate(other_direction, rotation)
    points[direction_util.offsets[other_direction]] = to_belts[other_direction]
  end

  if type == "splitter" then
    -- This is very gross. But rather than calculate bounding boxes, we just know
    -- that the position is in the southern or eastern box of the 2x1.
    local inverse_direction = direction_util.rotate(direction, 2)
    local from_direction = direction_util.rotate(defines.direction.northwest, math.floor(direction / 2.1) % 5)
    local to_direction = direction_util.rotate(defines.direction.southwest, math.ceil(direction / 8))
    points[direction_util.offsets[from_direction]] = from_belts[direction]
    points[direction_util.offsets[to_direction]] = to_belts[inverse_direction]
  end

  if type == "loader" then
    -- Due to our rounding, north and west will be off by one.
    if direction == defines.direction.north then
      points = { [{ x = 0, y = -2 }] = from_belts[direction] }
    elseif direction == defines.direction.west then
      points = { [{ x = -2, y = 0 }] = from_belts[direction] }
    end
  end

  return points
end

-- Return true if the entity would be belt connected to or from any tiles around it.
---@param entity LuaEntity
---@param mask SpaceMask
---@return boolean
---@nodiscard
function space_mask.test_to_from_belts(entity, mask)
  local direction = entity.direction
  if prototype_util.get_under_belt_type(entity) == "input" then
    direction = direction_util.rotate(direction, 2)
  end

  local match_mask = match_to_belts[direction]

  local rotation = direction / 4
  for _, other_direction in pairs(direction_util.directions[entity.type]) do
    match_mask = match_mask + match_from_belts[direction_util.rotate(other_direction, rotation)]
  end

  return bit32.btest(mask, match_mask)
end

-- Return true if the entity would be fluid connected to or from a specific tile.
---@param entity LuaEntity
---@param mask SpaceMask
---@param position MapPosition
---@return boolean
---@nodiscard
function space_mask.test_fluids(entity, mask, position)
  for i = 1, #entity.fluidbox do
    for _, connection in pairs(entity.fluidbox.get_pipe_connections(i)) do
      if
        connection.connection_type == "normal" and math2d.position.distance_squared(connection.position, position) < 1
      then
        local direction = direction_util.get_direction_from_offset(
          math2d.position.subtract(connection.target_position, connection.position)
        )
        if direction then
          local input = (connection.flow_direction == "input" or connection.flow_direction == "input-output")
          local output = (connection.flow_direction == "output" or connection.flow_direction == "input-output")
          local connection_mask = bit32.bor(
            input and space_mask.match_from_fluids[direction] or 0,
            output and space_mask.match_to_fluids[direction] or 0
          )
          if bit32.btest(mask, connection_mask) then
            return true
          end
        end
      end
    end
  end

  return false
end

return space_mask
