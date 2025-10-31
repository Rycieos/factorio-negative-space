local grid_map = require("scripts.util.grid_map")
local prototype_util = require("scripts.util.prototype")
local space_mask = require("scripts.util.space_mask")

local SpaceMask = space_mask.SpaceMask

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
  local setting_fluids = player_settings["__negative_space__-blueprint-fluids"].value --[[@as boolean]]
  if not (setting_belts or setting_fluids) then
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
      grid_map.insert(map, entity.position, SpaceMask.blocked)

      local real_entity = mapping[entity.entity_number]
      if real_entity then
        if setting_belts and prototype_util.entity_is_belt_connectable(prototype) then
          grid_map.suround_belt_entity(map, real_entity)
        end

        if setting_fluids then
          grid_map.map_fluid_entity(map, real_entity)
        end
      end
    end
  end

  local changed = false
  for x, row in pairs(map) do
    for y, mask in pairs(row) do
      local position = { x = x + 0.5, y = y + 0.5 }
      if bit32.btest(mask, SpaceMask.belt + SpaceMask.fluid) and not bit32.btest(mask, SpaceMask.blocked) then
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
            name = "negative-space-auto",
            position = position,
            tags = {
              negative_space_mask = mask,
            },
          })
        end
      end
    end
  end

  if changed then
    bp.set_blueprint_entities(entities)
  end
end
