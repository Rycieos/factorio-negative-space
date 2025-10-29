local item_sounds = require("__base__.prototypes.item_sounds")
local graphic = require("prototypes.graphic")

data:extend({
  {
    type = "item",
    name = "negative-space",
    icons = graphic.icons,
    flags = { "only-in-cursor", "not-stackable" },
    auto_recycle = false,
    subgroup = "spawnables",
    inventory_move_sound = item_sounds.wire_inventory_move,
    pick_sound = item_sounds.wire_inventory_pickup,
    drop_sound = item_sounds.wire_inventory_move,
    stack_size = 1,
    place_result = "negative-space",
  },
})
