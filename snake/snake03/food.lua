Food = {}
Food.__index = Food

function Food:new(row, col, value, color)
    return setmetatable({row = row, col = col, value = value or false, color = color or 2}, Food)
end

function Food:draw()
    local x = self.col * SQUARE_SIZE + SQUARE_SIZE // 2
    local y =  self.row * SQUARE_SIZE + SQUARE_SIZE // 2
    circ(x, y, SQUARE_SIZE // 4, self.color)
    if self.value then
        print(self.value, x - textWidth(self.value, 1) // 2 + 1, y - SQUARE_SIZE)
    end
end
