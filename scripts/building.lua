---@param surface LuaSurface
---@param player LuaPlayer
---@param position MapPosition
---@param undo_index uint32?
local function build_unstable_space(surface, player, position, undo_index)
  local entity = surface.create_entity({
    name = "negative-space",
    force = player.force,
    player = undo_index and player,
    position = position,
    create_build_effect_smoke = false,
    undo_index = undo_index,
  })
  if entity then
    entity.graphics_variation = 2
    -- We do not want this building event as a separate undo item. The API lets
    -- us down here. Ideally we would edit the redo record, but that is not
    -- possible, so a redo breaks the undo stack by merging multiple entries
    -- into one.
    if not undo_index then
      -- Assign the last user here instead of in create_entity(), because there it
      -- will add the build action to the player's undo queue.
      entity.last_user = player
    end
  end
end

---@param entity LuaEntity
---@param player LuaPlayer
local function replace_entity(entity, player)
  local surface = entity.surface
  local position = entity.position
  entity.mine()
  build_unstable_space(surface, player, position, 0)
end

---@param event EventData.on_built_entity
function on_built_entity(event)
  local entity = event.entity
  if entity.name == "negative-space" then
    entity.graphics_variation = 2
  else
    if entity.graphics_variation == 1 then
      local player = game.get_player(event.player_index)
      if not player then
        return
      end
      replace_entity(entity, player)
    else
      log("built an unstable ghost one")
      entity.mine()
    end
  end
end

---@param event EventData.on_undo_applied | EventData.on_redo_applied
function on_undo_redo(event)
  local player = game.get_player(event.player_index)
  if not player then
    return
  end
  for _, action in pairs(event.actions) do
    local target = action.target
    if target and action.type == "removed-entity" and target.name == "negative-space" then
      local surface = game.get_surface(action.surface_index)
      if surface then
        build_unstable_space(
          surface,
          player,
          target.position,
          event.name == defines.events.on_redo_applied and 1 or nil
        )
      end
    end
  end
end
