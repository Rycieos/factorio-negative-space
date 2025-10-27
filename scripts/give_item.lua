-- Put a negative-space ghost in the player's cursor.
---@param player_index uint32
function give_negative_space(player_index)
  local player = game.get_player(player_index)
  if player then
    player.clear_cursor()
    player.cursor_ghost = "negative-space"
  end
end
