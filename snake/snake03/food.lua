Food = {}
Food.__index = Food

function Food:new(row, col)
    return setmetatable({row = row, col = col}, Food)
end

function Food:draw()
    spr(7, self.col * SQUARE_SIZE, self.row * SQUARE_SIZE, 0)
end
