local graphic = {}

local style = settings.startup["__negative_space__-graphic-style"].value
local filename = style == "border" and "__negative_space__/graphics/negative-space-alt.png"
  or "__negative_space__/graphics/negative-space.png"

local tint = settings.startup["__negative_space__-graphic-color"].value --[[@as Color]]

---@type data.IconData[]
graphic.icons = {
  {
    icon = filename,
    icon_size = 64,
    tint = tint,
  },
}

---@type data.Sprite
graphic.picture = {
  filename = filename,
  size = 64,
  scale = 0.5,
  tint = tint,
}

---@type data.Animation
graphic.animation = {
  filenames = { filename },
  frame_count = 1,
  lines_per_file = 1,
  size = 64,
  scale = 0.5,
  tint = tint,
}

return graphic
