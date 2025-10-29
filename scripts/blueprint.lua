local bbutil = require("scripts.util.bounding_box")
local grid_map = require("scripts.util.grid_map")
local prototype_util = require("scripts.util.prototype")

local math2d = require("math2d")
local subtract = math2d.position.subtract

local GridMask = grid_map.GridMask

-- Add negative space to a new blueprint around belts and pipes.
---@param event EventData.on_player_setup_blueprint
---@param settings_override? {[string]: ModSetting} Used to override player settings in simulations.
function on_setup_blueprint(event, settings_override)
  -- See this thread for why this is so complicated:
  -- https://forums.factorio.com/viewtopic.php?p=661598#p661598
  ---@type LuaRecord|LuaItemStack
  local bp = event.stack

  if not bp or not bp.is_blueprint or not bp.is_blueprint_setup() then
    bp = event.record
    if not bp or not bp.is_blueprint_setup() then
      return
    end
  end

  local entities = bp.get_blueprint_entities()
  if not entities or #entities == 0 then
    return
  end

  local player_settings = settings_override or settings.get_player_settings(event.player_index)
  local setting_belts = player_settings["__negative_space__-blueprint-belts"].value --[[@as boolean]]
  local setting_pipes = player_settings["__negative_space__-blueprint-pipes"].value --[[@as boolean]]
  if not setting_belts and not setting_pipes then
    return
  end

  ---@type {[uint32]: LuaEntity}
  ---@diagnostic disable-next-line: assign-type-mismatch
  local mapping = event.mapping.get()

  ---@type GridMap
  local map = {}
  local surface = event.surface

  for _, entity in pairs(entities) do
    local prototype = prototypes.entity[entity.name]
    if prototype and prototype_util.entity_is_collidable(prototype) then
      -- Exclude the tile it is on. We will check for other collision later.
      grid_map.insert(map, entity.position, GridMask.blocked)

      local real_entity = mapping[entity.entity_number]
      if real_entity then
        if setting_belts and prototype_util.entity_is_belt_connectable(prototype) then
          -- It seems that the BP position and the real position are the same, but that might not always be the case.
          local box = bbutil.offset_and_round(real_entity.bounding_box, subtract(entity.position, real_entity.position))
          grid_map.suround(map, box, GridMask.belt)
        end

        if setting_pipes then
          for i = 1, #real_entity.fluidbox do
            for _, connection in pairs(real_entity.fluidbox.get_pipe_connections(i)) do
              if not connection.target then
                grid_map.insert(map, connection.target_position, GridMask.fluid)
              end
            end
          end
        end
      end
    end
  end

  local changed = false
  for x, row in pairs(map) do
    for y, grid_point in pairs(row) do
      local position = { x = x + 0.5, y = y + 0.5 }
      if bit32.btest(grid_point, GridMask.belt + GridMask.fluid) and not bit32.btest(grid_point, GridMask.blocked) then
        if
          surface.can_place_entity({
            name = "negative-space",
            position = position,
            build_check_type = defines.build_check_type.manual_ghost,
            -- Mimics how blueprinting ignores entities marked for deconstruction.
            forced = true,
          })
        then
          changed = true
          table.insert(entities, {
            entity_number = #entities + 1,
            name = "negative-space",
            position = position,
            variation = 2,
          })
        end
      end
    end
  end

  if changed then
    bp.set_blueprint_entities(entities)
  end
end
