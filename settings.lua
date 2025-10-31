data:extend({
  {
    name = "__negative_space__-graphic-color",
    type = "color-setting",
    setting_type = "startup",
    default_value = { r = 1.0, g = 0, b = 1.0 },
    order = "a[negative_space][icon]a",
  },
  {
    name = "__negative_space__-graphic-style",
    type = "string-setting",
    setting_type = "startup",
    default_value = "basic",
    allowed_values = {
      "basic",
      "border",
    },
    order = "a[negative_space][icon]b",
  },
  {
    name = "__negative_space__-blueprint-belts",
    type = "bool-setting",
    setting_type = "runtime-per-user",
    default_value = false,
    order = "a[negative_space][blueprint][a]belts",
  },
  {
    name = "__negative_space__-blueprint-fluids",
    type = "bool-setting",
    setting_type = "runtime-per-user",
    default_value = false,
    order = "a[negative_space][blueprint][a]fluids",
  },
  {
    name = "__negative_space__-behavior-belts",
    type = "string-setting",
    setting_type = "runtime-per-user",
    default_value = "any",
    allowed_values = {
      "any",
      "belts",
      "directional",
    },
    order = "a[negative_space][blueprint][b]belts",
  },
  {
    name = "__negative_space__-behavior-fluids",
    type = "string-setting",
    setting_type = "runtime-per-user",
    default_value = "any",
    allowed_values = {
      "any",
      "fluids",
      "directional",
    },
    order = "a[negative_space][blueprint][b]fluids",
  },
})
