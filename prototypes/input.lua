local graphic = require("prototypes.graphic")

data:extend({
  {
    type = "custom-input",
    name = "give-negative-space",
    key_sequence = "CONTROL + SHIFT + N",
    order = "a",
    localised_name = { "shortcut-name.give-negative-space" },
    action = "lua",
  },
  {
    type = "shortcut",
    name = "give-negative-space",
    action = "lua",
    associated_control_input = "give-negative-space",
    icons = graphic.icons,
    small_icons = graphic.icons,
  },
})
