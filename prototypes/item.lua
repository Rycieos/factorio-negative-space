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
  {
    type = "item",
    name = "negative-space-auto",
    icons = graphic.icons,
    flags = { "only-in-cursor", "not-stackable" },
    auto_recycle = false,
    subgroup = "spawnables",
    stack_size = 1,
    place_result = "negative-space-auto",
  },
  {
    type = "selection-tool",
    name = "negative-space-tool",
    icons = graphic.icons,
    flags = { "only-in-cursor", "not-stackable", "spawnable" },
    hidden = true,
    select = {
      border_color = graphic.tint,
      cursor_box_type = "entity",
      mode = "nothing",
    },
    alt_select = {
      border_color = graphic.tint,
      cursor_box_type = "entity",
      mode = {
        "deconstruct",
        "same-force",
      },
      entity_filter_mode = "whitelist",
      entity_filters = {
        "negative-space",
      },
    },
    reverse_select = {
      border_color = graphic.tint,
      cursor_box_type = "entity",
      mode = {
        "deconstruct",
        "same-force",
      },
      entity_filter_mode = "whitelist",
      entity_filters = {
        "negative-space",
      },
    },
    auto_recycle = false,
    subgroup = "spawnables",
    inventory_move_sound = item_sounds.planner_inventory_move,
    pick_sound = item_sounds.planner_inventory_pickup,
    drop_sound = item_sounds.planner_inventory_move,
    stack_size = 1,
  },
})
