function textWidth(text, scale)
  local scale = scale or 1
  return string.len(text) * DEFAULT_FONT_WIDTH * scale
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end
