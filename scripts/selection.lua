---@param event EventData.on_player_selected_area
function on_player_selected_area(event)
  local player = game.get_player(event.player_index)
  if not player then
    return
  end

  local surface = event.surface
  local undo_index = 0

  for x = math.floor(event.area.left_top.x), math.floor(event.area.right_bottom.x) do
    for y = math.floor(event.area.left_top.y), math.floor(event.area.right_bottom.y) do
      local position = { x = x, y = y }
      if
        surface.can_place_entity({
          name = "negative-space",
          position = position,
          build_check_type = defines.build_check_type.manual,
          forced = false,
        })
      then
        surface.create_entity({
          name = "negative-space",
          force = player.force,
          player = player,
          position = position,
          create_build_effect_smoke = false,
          undo_index = undo_index,
        })
        if undo_index == 0 then
          undo_index = 1
        end
      end
    end
  end
end

---@param event EventData.on_player_alt_selected_area | EventData.on_player_reverse_selected_area
function on_player_reverse_selected_area(event)
  local player = game.get_player(event.player_index)
  if not player then
    return
  end

  -- We want the whole select action to be one undo event. Make the first
  -- deconstruct a new event, and all the others added onto it.
  local undo_index = 0
  for _, entity in pairs(event.entities) do
    if entity.valid then
      entity.destroy({ player = player, undo_index = undo_index })
      if undo_index == 0 then
        undo_index = 1
      end
    end
  end
end
