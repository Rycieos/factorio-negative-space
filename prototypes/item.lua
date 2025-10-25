local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
  {
    type = "item",
    name = "negative-space",
    icon = "__negative_space__/graphics/icon.png",
    icon_size = 48,
    flags = { "only-in-cursor", "not-stackable", "spawnable" },
    auto_recycle = false,
    subgroup = "spawnables",
    inventory_move_sound = item_sounds.wire_inventory_move,
    pick_sound = item_sounds.wire_inventory_pickup,
    drop_sound = item_sounds.wire_inventory_move,
    stack_size = 1,
    place_result = "stable-negative-space",
  },
})
