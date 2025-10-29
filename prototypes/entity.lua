local graphic = require("prototypes.graphic")

data:extend({
  {
    type = "simple-entity-with-owner",
    name = "negative-space",
    alert_when_damaged = false,
    create_ghost_on_death = true,
    hide_resistances = true,
    healing_per_tick = 0.1,
    collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    collision_mask = {
      layers = {
        object = true,
        is_lower_object = true,
      },
    },
    flags = {
      "placeable-player",
      "player-creation",
      "not-flammable",
      "not-upgradable",
      "not-in-kill-statistics",
    },
    icons = graphic.icons,
    minable = { mining_time = 0.1 },
    placeable_by = { item = "negative-space", count = 1 },
    protected_from_tile_building = false,
    remove_decoratives = "false",
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    pictures = {
      graphic.picture,
      graphic.picture,
    },
    -- We will use graphics_variation as our stable flag.
    random_variation_on_create = false,
    render_layer = "lower-object",
  },
})
