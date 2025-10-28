---@param x double
---@param y double
---@return fun(): boolean
function move_cursor(x, y)
  return function()
    return game.simulation.move_cursor({ position = { x, y } })
  end
end

---@param control string
---@return fun()
function control_press(control)
  return function()
    game.simulation.control_press({
      control = control,
      notify = player.input_method ~= defines.input_method.game_controller,
    })
  end
end

---@param control string
---@param direction "up"|"down"
---@return fun()
function control_up_or_down(control, direction)
  return function()
    if direction == "down" then
      game.simulation.control_down({ control = control, notify = false })
    else
      game.simulation.control_up({ control = control, notify = false })
    end
  end
end

---@param phase "start"|"end"
---@return fun()
function select_drag(phase)
  return function()
    if player.input_method ~= defines.input_method.game_controller then
      if phase == "start" then
        game.simulation.control_down({ control = "select-for-blueprint", notify = false })
      else
        game.simulation.control_up({ control = "select-for-blueprint", notify = false })
      end
    else
      game.simulation.control_press({ control = "select-for-blueprint", notify = false })
    end
  end
end
