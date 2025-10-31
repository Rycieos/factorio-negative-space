require("__core__/lualib/story")
require("__negative_space__/prototypes/simulation/util")
require("__negative_space__/control")

player = game.simulation.create_test_player({ name = "Player" })
player.teleport({ 0, 8.5 })
game.simulation.camera_player = player
game.simulation.camera_position = { 0, 1 }
game.simulation.camera_zoom = 1.3
game.simulation.camera_player_cursor_position = player.position
game.simulation.camera_alt_info = true

-- Required for the chemical lab recipes to work.
player.force.research_all_technologies()

game.surfaces[1].create_entities_from_blueprint_string({
  string = "0eNq1WeuSoyoQfhd+a8obqPMqU6kU0U6WWoMu4uzmTOXdD+rkshNMmlA7vyai39d3muaTbJsBOiWkJm+fRFSt7Mnb+yfpxV7yZnwm+QHIG4E/nYK+D7Xisu9apcMtNJqcAiJkDX/IW3wKLJ9VXO3bcMuPJCC/Bt4IfTRPG9iDrLk63nyfnNYBAamFFjDLMP04buRw2IIyBMEZVMidkGYprH5Arw1y1/bms1aOxKMoUbSiATFMIVvRiWL+YNOD1kLu+/FFBYf2AzaDWWs0KKg3QsPBLGk1QEDmp7MkZ2XargMVtgoMZ9UOo9FoFJBDW4/LXIcN8Emgi03Wp9Es3zRJHDQp/4kmQrXSX48Ur0f8bzzSD81uUH5aZMH3GG9aXoN6GFejDrVQUM3LRUD0sRsx2kF3w5gXdzw0uEq97TWfvrRwXBgsGOwqa2O4lahCkKD2x9BkMKgdr8AGmV+F3g67HahNL/6DSaHzn4UsdzBM6WGYAs8T+zigDJ4Us0cOT1bfGS0MceRDkaIo4hcoSjeKxIcCZ6jUnSJ2NFTmQ4HTgvq4O0ZRMB+KCEWR+7gbp0XhQ4HTovRxN0qLJPKhQGmRxB7uvmPIbAyvJHfsxHCf231nGj9t3zmSL+wYgZx5hBHOxdSDAedh5hFEOIbcgwFnpWs670yHZXqPHtQT944F1QZVOnVFqbUNjTychir0qc+me7dbxYmN4pW8LNwofDZdnJ189lzUrp7S+w7YnADkQuN7LlyZPfpShg/k4gnUfdYN5tih9sqcTOqnymerxYZWyIV+NnVIw7Mh2IL0JR4q/YLKMZtB9kpu0hthn0ZEFnsw5KjEyV7JzcyNIsU7gC2Zx+qAzClhisdxkrnvj+UZskR5k71OUKAIcqyhy3IJ12rnazJWP+AgKt6EXcPlw36qsGS9+V9Meb/lY8s0Ds7mR5vr/Ey26sCbcbIxz0feP4mob6ZufQdQh4e2HhoI02nINr9o3pMbIT+M8K2Bnj68/jKhYnbg6qdpNEYNrSvx4koyjlfWNtM4FJf8xjK2GUrkVWWL1Stzm9hjU0MFPU1eD/oY1RPS1IMB1RPSa53pxvh9cE6ZAG0QFA8RLUCwvyBC3YZzaDzKwnsFrSWa5g7Y2SK2rXhQl+LBFj2f3VSPeTJqij2vRP2ghtikKZ/6oXjiSha5N1Yx6nTJfFrxewqrp1nic4JCcryQkRc1UpSlMo+cxzF4dAMx6kDBfMZfSCVyj4FIjDq0sAKfUAvnZOaQk6kdIo98FM0wiuYxXkq6IGWCh1g4iuUO91JXBfMX76WsErjcKV0kYM4nwJzea/rUag8U/cL6zb9KNajKMPI9TLevRmfzhOtBwTz7/n7TZjUFw/tzOnSsA/LbGGHsat9pQIOkDOh6PXewY1d8ua8OyAeofgKiLCmzsqR5maVJyU6n/wEJSifM",
  position = { 0, 0 },
})

local next = "belts"
local settings_override = {}

---@param belts boolean
---@param fluids boolean
local function override_settings(belts, fluids)
  settings_override["__negative_space__-blueprint-belts"] = { value = belts }
  settings_override["__negative_space__-blueprint-fluids"] = { value = fluids }
end

-- Re-register to inject custom settings values. The game does not let us change
-- these settings, even though we created them, because it does not think this
-- scenario is part of the mod.
script.on_event(defines.events.on_player_setup_blueprint, function(event)
  on_setup_blueprint(event, settings_override)
end)

tip_story_init({
  {
    {
      name = "start",
      action = function()
        game.simulation.camera_player_cursor_direction = defines.direction.north

        -- Cycle through the settings to show the player their options.
        if next == "belts" then
          override_settings(true, false)
          next = "fluids"
        elseif next == "fluids" then
          override_settings(false, true)
          next = "both"
        else
          override_settings(true, true)
          next = "belts"
        end
      end,
    },
    {
      condition = move_cursor(-3, 3.5),
      action = control_press("give-blueprint"),
    },
    {
      condition = move_cursor(-6, -6),
      action = select_drag("start"),
    },
    {
      condition = move_cursor(7, 8),
      action = select_drag("end"),
    },
    {
      condition = move_cursor(0, 8.5),
    },

    {
      condition = story_elapsed_check(4),
      action = function()
        player.opened = nil
        player.clear_cursor()
      end,
    },
    {
      condition = story_elapsed_check(1),
      action = function()
        story_jump_to(storage.story, "start")
      end,
    },
  },
})
