local graphic = {}

graphic.icons = {
  {
    icon = "__negative_space__/graphics/negative-space.png",
    icon_size = 64,
    tint = settings.startup["__negative_space__-graphic-color"].value,
  },
}

graphic.picture = {
  filename = "__negative_space__/graphics/negative-space.png",
  size = 64,
  scale = 0.5,
  tint = settings.startup["__negative_space__-graphic-color"].value,
}

return graphic
