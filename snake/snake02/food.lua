Food = {}
Food.__index = Food

function Food:new(row, col, value, color)
    return setmetatable({row = row, col = col, value = value or 0, color = color or 2}, Food)
end

function Food:draw()
    circ(
        self.col * SQUARE_SIZE + SQUARE_SIZE // 2,
        self.row * SQUARE_SIZE + SQUARE_SIZE // 2,
        SQUARE_SIZE // 4, self.color
    )
end
