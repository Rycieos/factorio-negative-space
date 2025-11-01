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

local next = "any"
local settings_override = {
  ["__negative_space__-blueprint-belts"] = { value = true },
  ["__negative_space__-blueprint-fluids"] = { value = true },
}

---@param value string
local function override_settings(value)
  settings_override["__negative_space__-behavior-belts"] = { value = value }
  settings_override["__negative_space__-behavior-fluids"] = { value = value }
end

-- Re-register to inject custom settings values. The game does not let us change
-- these settings, even though we created them, because it does not think this
-- scenario is part of the mod.
script.on_event(defines.events.on_player_setup_blueprint, function(event)
  on_setup_blueprint(event, settings_override)
end)
script.on_event(defines.events.on_built_entity, function(event)
  on_built_entity(event, settings_override)
end, {
  { filter = "ghost" },
  { mode = "and", filter = "ghost_name", name = "negative-space-auto" },
})

tip_story_init({
  {
    {
      name = "start",
      action = function()
        game.simulation.camera_player_cursor_direction = defines.direction.north

        for _, entity in pairs(game.surfaces[1].find_entities_filtered({ area = { { -5, -5 }, { 2, 6 } } })) do
          entity.destroy()
        end
        game.surfaces[1].create_entities_from_blueprint_string({
          string = "0eNqdmOGSojAMx9+ln8sOLS1QX2XH2UGtXme0MFD2znN49wP3XN01LGn8JFh/SdP807QXtjn2tmmdD2x1YW5b+46tXi+scwdfHad3vjpZtmKhrXzX1G1INvYY2MCZ8zv7h63EwIHh21/25LbVMWmOlX8cLoc1Z9YHF5z9MHV9OL/5/rSx7cjjN0bXb7pQBVd7xllTd+76dbQxWU01Z2e2ysphsv+NIT8Z9mi3oXXbxHrbHs7JOFHb7quthZDFDcnZpt/vbfvWub92+uXzAxjL+EyMAAvpy4fbSrxoyHFFYUmYpSmsDGblFJaCWQWFpWFWSWEVMMtQWDnMEimfUQIAk0uwOEmoHITIiOmZx1BxtnPtqKLrgBJC4xVg9I1cficriKwIZIMi49Vhijif8VoxeZzPBYGM87kkRAPnM15VpowiyxRPNlHRkILgM44sCT7jokHahXBo0qZUwrVM3nXXuMYmoU4Obd37HQTLlmA5paYZTE2TBQVdotBlfFHTKWqlTHyBwJGzNL5AIMkiXhJIsoyXMZJ8F9uYuWNfec3gRU1o8ZQenIVzM3Gcb/qpTX62RVHf8zSgRMw0IceBSUBoijKRXhf41kqIRzQEK9Gwe45kqBwxUTkiZuFT4/Y/Seo+zGSJuutzX3VhPOZ0th1POj8mCWoeShDIEkWWhK3g2WkoR1TMbqh/CD3EVlELqzALO6t+FSPRPHIi+Zf4Q/L5sqAQolhC3BN75jSoSlot1fO19AeZmEV/0wV/dbqIyJYQYhEhlxCSsiugTnOa0knqHIUm7WWofk1Tbjs00K+tOfs9Pk9XU6+Caz4evvV6fOmCPY3w+3UZZ++27a7/0rk0yhhdisyYVA3DP7NuQNE=",
          position = { 0, -2 },
        })

        -- Cycle through the settings to show the player their options.
        override_settings(next)
        if next == "any" then
          next = "type"
        elseif next == "type" then
          next = "directional-type"
        else
          next = "any"
        end
      end,
    },
    {
      condition = move_cursor(2, 3.5),
      action = control_press("copy"),
    },
    {
      condition = move_cursor(4.5, -3.5),
      action = select_drag("start"),
    },
    {
      condition = move_cursor(9.5, 3.5),
      action = select_drag("end"),
    },
    {
      condition = move_cursor(-1.5, 1),
      action = control_press("build"),
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        player.clear_cursor()
      end,
    },
    {
      condition = move_cursor(0, 8.5),
    },

    {
      condition = story_elapsed_check(4),
      action = function()
        story_jump_to(storage.story, "start")
      end,
    },
  },
})
