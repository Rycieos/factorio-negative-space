local bbutil = {}

-- Offset a bounding box from its origin, rounding to the largest whole tiles.
-- Handles normalisation.
---@param box BoundingBox
---@param position MapPosition
---@return BoundingBox
---@nodiscard
function bbutil.offset_and_round(box, position)
  local left_top = box.left_top or box[1]
  local right_bottom = box.right_bottom or box[2]
  return {
    left_top = {
      x = math.floor((left_top.x or left_top[1]) + position.x),
      y = math.floor((left_top.y or left_top[2]) + position.y),
    },
    right_bottom = {
      x = math.floor((right_bottom.x or right_bottom[1]) + position.x),
      y = math.floor((right_bottom.y or right_bottom[2]) + position.y),
    },
  }
end

-- Get the orthoginally surounding points of the bounding box.
---@param box BoundingBox
---@return MapPosition[]
function bbutil.get_surounding_points(box)
  local points = {}

  local left_top_x = box.left_top.x
  local left_top_y = box.left_top.y
  local right_bottom_x = box.right_bottom.x
  local right_bottom_y = box.right_bottom.y

  for x = left_top_x, right_bottom_x do
    table.insert(points, { x = x, y = left_top_y - 1 })
    table.insert(points, { x = x, y = right_bottom_y + 1 })
  end
  for y = left_top_y, right_bottom_y do
    table.insert(points, { x = left_top_x - 1, y = y })
    table.insert(points, { x = right_bottom_x + 1, y = y })
  end

  return points
end

return bbutil
