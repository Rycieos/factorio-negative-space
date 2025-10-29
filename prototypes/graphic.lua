local graphic = {}

local style = settings.startup["__negative_space__-graphic-style"].value
local filename = style == "border" and "__negative_space__/graphics/negative-space-alt.png"
  or "__negative_space__/graphics/negative-space.png"

graphic.icons = {
  {
    icon = filename,
    icon_size = 64,
    tint = settings.startup["__negative_space__-graphic-color"].value,
  },
}

graphic.picture = {
  filename = filename,
  size = 64,
  scale = 0.5,
  tint = settings.startup["__negative_space__-graphic-color"].value,
}

return graphic
