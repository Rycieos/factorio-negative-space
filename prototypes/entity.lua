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
      "not-rotatable",
      "placeable-player",
      "player-creation",
      "not-flammable",
      "not-upgradable",
      "not-in-kill-statistics",
    },
    icon = "__negative_space__/graphics/icon.png",
    icon_size = 48,
    minable = { mining_time = 0.1 },
    placeable_by = { item = "negative-space", count = 1 },
    protected_from_tile_building = false,
    remove_decoratives = "false",
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    pictures = {
      {
        filename = "__negative_space__/graphics/icon.png",
        size = 48,
      },
      {
        filename = "__negative_space__/graphics/icon.png",
        size = 48,
      },
    },
    -- We will use graphics_variation as our stable flag.
    random_variation_on_create = false,
  },
})
