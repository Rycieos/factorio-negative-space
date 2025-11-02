require("scripts.blueprint")
require("scripts.building")
require("scripts.give_item")

script.on_event(defines.events.on_built_entity, on_built_entity, {
  { filter = "name", name = "negative-space" },
  { mode = "or", filter = "ghost" },
  { mode = "and", filter = "ghost_name", name = "negative-space" },
  { mode = "or", filter = "name", name = "negative-space-auto" },
  { mode = "or", filter = "ghost" },
  { mode = "and", filter = "ghost_name", name = "negative-space-auto" },
})

script.on_event({ defines.events.on_undo_applied, defines.events.on_redo_applied }, on_undo_redo)

script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name == "give-negative-space" then
    give_negative_space(event.player_index)
  end
end)

---@param event EventData.CustomInputEvent
script.on_event("give-negative-space", function(event)
  give_negative_space(event.player_index)
end)

-- It is possible to get an actual item in cheat mode.
-- Also can get the auto version when pipetting.
script.on_event(defines.events.on_player_pipette, function(event)
  if event.item.name == "negative-space-auto" then
    give_negative_space(event.player_index)
  end
end)

script.on_event(defines.events.on_player_setup_blueprint, on_setup_blueprint)
