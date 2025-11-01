local direction_util = require("scripts.util.direction")
local math2d = require("math2d")
local prototype_util = require("scripts.util.prototype")
local space_mask = require("scripts.util.space_mask")

---@alias GridMap table<int32, table<int32, SpaceMask>>

local grid_map = {}

---@param map GridMap
---@param x int32
---@return table<int32, SpaceMask>
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
---@param mask SpaceMask
function grid_map.insert(map, position, mask)
  position = ensure_xy(position)
  local x = ensure_x(map, position.x)
  x[position.y] = bit32.bor((x[position.y] or 0), mask)
end

-- Insert required masks surounding the belt connecting entity.
---@param map GridMap
---@param entity LuaEntity
function grid_map.suround_belt_entity(map, entity)
  local belt_type = prototype_util.get_under_belt_type(entity)
  local point_offsets = space_mask.generate_transport_belt_points(entity.type, entity.direction, belt_type)
  local position = entity.position
  for offset, mask in pairs(point_offsets) do
    grid_map.insert(
      map,
      math2d.position.add(
        { x = math.floor(position.x or position[1]), y = math.floor(position.y or position[2]) },
        offset
      ),
      mask
    )
  end
end

---comment
---@param map GridMap
---@param entity LuaEntity
function grid_map.map_fluid_entity(map, entity)
  for i = 1, #entity.fluidbox do
    for _, connection in pairs(entity.fluidbox.get_pipe_connections(i)) do
      if connection.connection_type == "normal" and not connection.target then
        local direction = direction_util.get_direction_from_offset(
          math2d.position.subtract(connection.target_position, connection.position)
        )
        if direction then
          local input = (connection.flow_direction == "input" or connection.flow_direction == "input-output")
          local output = (connection.flow_direction == "output" or connection.flow_direction == "input-output")
          local mask =
            bit32.bor(input and space_mask.to_fluids[direction] or 0, output and space_mask.from_fluids[direction] or 0)
          grid_map.insert(map, connection.target_position, mask)
        end
      end
    end
  end
end

-- Check if an entity should not be deconstructed.
-- "should be saved" is really tricky, because the enitity might cover multiple
-- tiles. If the player setting behavior-pipes is "only pipes", then we don't
-- want to remove an assembling machine, unless it has a pipe connection in the
-- tile that has a pipe connectable space.
-- So our return values are "true": remove it, or "false": don't care.
---@param entity LuaEntity
---@param mask SpaceMask
---@param mask_position MapPosition
---@param player_settings {[string]: ModSetting}
---@return boolean
---@nodiscard
function grid_map.should_be_removed(entity, mask, mask_position, player_settings)
  local setting_belts = player_settings["__negative_space__-behavior-belts"].value --[[@as string]]
  local setting_fluids = player_settings["__negative_space__-behavior-fluids"].value --[[@as string]]

  if bit32.btest(mask, space_mask.SpaceMask.belt) then
    if setting_belts == "any" then
      return true
    end
    if prototype_util.entity_is_belt_connectable(entity) then
      if setting_belts == "type" then
        return true
      else
        return space_mask.test_to_from_belts(entity, mask)
      end
    end
  end
  if bit32.btest(mask, space_mask.SpaceMask.fluid) then
    if setting_fluids == "any" then
      return true
    end
    if #entity.fluidbox > 0 then
      if setting_fluids == "type" then
        return true
      else
        return space_mask.test_fluids(entity, mask, mask_position)
      end
    end
  end

  return false
end

return grid_map
