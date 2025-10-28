local math2d = require("math2d")
local position_add = math2d.position.add
local position_ensure_xy = math2d.position.ensure_xy

---@alias GridMap table<int32, table<int32, GridMask>>

local grid_map = {}

---@enum GridMaskEnum
grid_map.GridMask = {
  empty = 0,
  blocked = 1,
  belt = 2,
  fluid = 4,
}

---@alias GridMask GridMaskEnum|int8

---@param map GridMap
---@param x int32
---@return table<int32, GridMask>
local function ensure_x(map, x)
  if not map[x] then
    map[x] = {}
  end
  return map[x]
end

-- Get the mask at a position.
---@param map GridMap
---@param position MapPosition
---@return GridMask?
---@nodiscard
local function get(map, position)
  position = position_ensure_xy(position)
  return ensure_x(map, position.x)[position.y]
end
grid_map.get = get

-- Insert a mask into a position. Merges with any value already there, meaning a
-- bitwise or.
---@param map GridMap
---@param position MapPosition
---@param mask GridMask
local function insert(map, position, mask)
  position = position_ensure_xy(position)
  local x = ensure_x(map, position.x)
  x[position.y] = bit32.bor((x[position.y] or 0), mask)
end
grid_map.insert = insert

-- Insert a mask into the 4 tiles orthoginally surounding the position.
---@param map GridMap
---@param position MapPosition
---@param mask GridMask
function grid_map.suround(map, position, mask)
  insert(map, position_add(position, { x = -1, y = 0 }), mask)
  insert(map, position_add(position, { x = 1, y = 0 }), mask)
  insert(map, position_add(position, { x = 0, y = -1 }), mask)
  insert(map, position_add(position, { x = 0, y = 1 }), mask)
end

-- Returns true if the grid point at position matches at least one bit of mask,
-- but does not match any bits of not_mask.
---@param map GridMap
---@param position MapPosition
---@param mask GridMask
---@param not_mask? GridMask
---@return boolean
---@nodiscard
function grid_map.matches(map, position, mask, not_mask)
  local pos_mask = get(map, position)
  if not_mask and bit32.btest(pos_mask, not_mask) then
    return false
  end
  return bit32.btest(pos_mask, mask)
end

return grid_map
