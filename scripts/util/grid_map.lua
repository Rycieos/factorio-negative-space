local bbutil = require("scripts.util.bounding_box")

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

--
---@param position MapPosition
---@return {x: int32, y: int32}
local function ensure_xy(position)
  return { x = math.floor(position.x or position[1]), y = math.floor(position.y or position[2]) }
end

-- Insert a mask into a position. Merges with any value already there, meaning a
-- bitwise or.
---@param map GridMap
---@param position MapPosition
---@param mask GridMask
local function insert(map, position, mask)
  position = ensure_xy(position)
  local x = ensure_x(map, position.x)
  x[position.y] = bit32.bor((x[position.y] or 0), mask)
end
grid_map.insert = insert

-- Insert a mask into the tiles orthoginally surounding the bounding box.
---@param map GridMap
---@param box BoundingBox
---@param mask GridMask
function grid_map.suround(map, box, mask)
  for _, position in pairs(bbutil.get_surounding_points(box)) do
    insert(map, position, mask)
  end
end

return grid_map
