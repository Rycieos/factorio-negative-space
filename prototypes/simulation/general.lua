require("__core__/lualib/story")
require("__negative_space__/prototypes/simulation/util")

-- Unregister to prevent auto creating negative space on copy.
script.on_event(defines.events.on_player_setup_blueprint, nil)

player = game.simulation.create_test_player({ name = "Player" })
player.teleport({ 0, 5.5 })
game.simulation.camera_player = player
game.simulation.camera_position = { 0, 1 }
game.simulation.camera_player_cursor_position = player.position

tip_story_init({
  {
    {
      name = "start",
      action = function()
        for _, entity in pairs(game.surfaces[1].find_entities_filtered({ area = { { -7, -3 }, { 7, 3 } } })) do
          entity.destroy()
        end
        game.surfaces[1].create_entities_from_blueprint_string({
          string = "0eNqdl9tqg0AURf/lPE+DztXxV0opuQxFSCZBTWkI/ntN8tBCs5PZffRylmuDm6NnWW2P6dB3eZT2LN16nwdpX88ydB95ub2cy8tdklbGfpmHw74fX1ZpO8qkpMub9CVtPb0pSXnsxi7dZq8Hp/d83K1SP9+gAEPJYT/MY/t8ec6M8nHhlJyktQs3TeoPSfMkd59kyknNYyfLk4CTKyYF89jJ8yTgFMpJ+hdJyabr0/p22d7hNuVc+zhr5Ekga12VoxwKW+t75PIKhCcVqDWPQnnLSxCelKC2PApZOb7kHqA8jwoAFfiaI6uGRyGryNcTWOmKRwErXfM9QlaaRyErwxcHWVkehawcXxxk5XkUsgp8cRqA+sfbjlCRt4pg/Ve8FULVfHFAQKP5vd0ULSBjeDLKa/lKoryO391NydeF8TwYxQ1811Hchi8oQkXeCgS0FW91Rc1f/d2YdvPczy+Eks/UD9cJ53W0MboQrdHRT9M3d/APdQ==",
          position = { 0, 0 },
        })
      end,
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        game.simulation.camera_player_cursor_direction = defines.direction.north
      end,
    },
    {
      condition = move_cursor(0, 2),
      action = control_press("copy"),
    },
    {
      condition = move_cursor(-2, -3),
      action = select_drag("start"),
    },
    {
      condition = move_cursor(2, 3),
      action = select_drag("end"),
    },
    {
      condition = move_cursor(-5, 0),
    },
    {
      condition = story_elapsed_check(0.25),
      action = control_press("super-forced-build"),
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        player.clear_cursor()
      end,
    },
    {
      condition = story_elapsed_check(0.5),
    },
    {
      condition = move_cursor(-0.5, -0.5),
      action = control_press("give-negative-space"),
    },
    {
      condition = story_elapsed_check(0.25),
      action = control_up_or_down("build", "down"),
    },
    {
      condition = move_cursor(0.5, -0.5),
    },
    {
      condition = move_cursor(0.5, 0.5),
    },
    {
      condition = move_cursor(-0.5, 0.5),
      action = control_up_or_down("build", "up"),
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        player.clear_cursor()
      end,
    },
    {
      condition = story_elapsed_check(0.25),
      action = control_press("copy"),
    },
    {
      condition = move_cursor(-2, -3),
      action = select_drag("start"),
    },
    {
      condition = move_cursor(2, 3),
      action = select_drag("end"),
    },
    {
      condition = move_cursor(5, 0),
    },
    {
      condition = story_elapsed_check(0.25),
      action = control_press("super-forced-build"),
    },
    {
      condition = story_elapsed_check(0.25),
      action = function()
        player.clear_cursor()
      end,
    },

    {
      condition = move_cursor(0, 5.5),
    },
    {
      condition = story_elapsed_check(2),
      action = function()
        story_jump_to(storage.story, "start")
      end,
    },
  },
})
