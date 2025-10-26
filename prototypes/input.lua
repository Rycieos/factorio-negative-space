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
    icon = "__negative_space__/graphics/icon.png",
    icon_size = 48,
    small_icon = "__negative_space__/graphics/icon.png",
    small_icon_size = 48,
  },
})
