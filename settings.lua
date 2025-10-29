data:extend({
  {
    name = "__negative_space__-graphic-color",
    type = "color-setting",
    setting_type = "startup",
    default_value = { r = 1.0, g = 0, b = 1.0 },
    order = "a[negative_space][icon]",
  },
  {
    name = "__negative_space__-blueprint-belts",
    type = "bool-setting",
    setting_type = "runtime-per-user",
    default_value = false,
    order = "a[negative_space][blueprint]belts",
  },
  {
    name = "__negative_space__-blueprint-pipes",
    type = "bool-setting",
    setting_type = "runtime-per-user",
    default_value = false,
    order = "a[negative_space][blueprint]pipes",
  },
})
