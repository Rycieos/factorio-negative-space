data:extend({
  {
    type = "tips-and-tricks-item",
    name = "negative-space",
    tag = "[entity=negative-space]",
    category = "ghost-building",
    order = "d[negative-space]a",
    indent = 1,
    trigger = {
      type = "research",
      technology = "construction-robotics",
    },
    dependencies = { "ghost-building", "copy-paste" },
    simulation = {
      init_file = "__negative_space__/prototypes/simulation/general.lua",
    },
  },
  {
    type = "tips-and-tricks-item",
    name = "negative-space-blueprint",
    tag = "[entity=negative-space][item=blueprint]",
    category = "ghost-building",
    order = "d[negative-space]b",
    indent = 1,
    trigger = {
      type = "research",
      technology = "construction-robotics",
    },
    dependencies = { "negative-space" },
    simulation = {
      init_file = "__negative_space__/prototypes/simulation/blueprint.lua",
    },
  },
})
