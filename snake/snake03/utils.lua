function textWidth(text, scale)
  local scale = scale or 1
  return string.len(text) * DEFAULT_FONT_WIDTH * scale
end
