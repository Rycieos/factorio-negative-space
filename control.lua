---@param surface LuaSurface
---@param player LuaPlayer
---@param position MapPosition
---@param new_undo_item boolean
local function build_unstable_space(surface, player, position, new_undo_item)
  surface.create_entity({
    name = "unstable-negative-space",
    force = player.force,
    player = player,
    position = position,
    create_build_effect_smoke = false,
    undo_index = 0,
  })
  -- We do not want this building event as a separate undo item.
  -- The API lets us down here. Ideally we would edit the redo record, but that
  -- is not possible, so an undo or redo breaks the redo stack.
  if not new_undo_item then
    player.undo_redo_stack.remove_undo_item(1)
  end
end

---@param entity LuaEntity
---@param player LuaPlayer
local function replace_entity(entity, player)
  local surface = entity.surface
  local position = entity.position
  entity.mine()
  build_unstable_space(surface, player, position, true)
end

---@param event EventData.on_built_entity
local function on_built_entity(event)
  local entity = event.entity
  local player = game.get_player(event.player_index)
  if not player then
    return
  end
  if entity.name == "stable-negative-space" then
    replace_entity(entity, player)
  elseif entity.type == "entity-ghost" then
    if entity.ghost_name == "stable-negative-space" then
      replace_entity(entity, player)
    else
      entity.mine()
    end
  end
end

script.on_event(defines.events.on_built_entity, on_built_entity, {
  { filter = "ghost" },
  { mode = "and", filter = "ghost_name", name = "unstable-negative-space" },
  { mode = "or", filter = "ghost" },
  { mode = "and", filter = "ghost_name", name = "stable-negative-space" },
  { mode = "or", filter = "name", name = "stable-negative-space" },
})

---@param event EventData.on_undo_applied | EventData.on_redo_applied
local function on_undo_redo(event)
  local player = game.get_player(event.player_index)
  if not player then
    return
  end
  for _, action in pairs(event.actions) do
    local target = action.target
    if target and action.type == "removed-entity" and target.name == "unstable-negative-space" then
      local surface = game.get_surface(action.surface_index)
      if surface then
        build_unstable_space(surface, player, target.position, false)
      end
    end
  end
end

script.on_event({ defines.events.on_undo_applied, defines.events.on_redo_applied }, on_undo_redo)
