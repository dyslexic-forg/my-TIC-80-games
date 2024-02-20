local function snakeEatFood(snake, food)
    return snake.head.row == food.row and snake.head.col == food.col
end

GameScene = {}
GameScene.__index = GameScene

function GameScene:new()
    local scene = setmetatable({}, GameScene)
    scene.snake = Snake:new(GRID_HEIGHT // 2, 3, "right")
    scene.food = Food:new(GRID_HEIGHT // 2, GRID_WIDTH // 2)
    return scene
end

function GameScene:draw()
    cls(13)
    self.food:draw()
    self.snake:draw()
end

function GameScene:update(dt)
    if btnp(0) then self.snake:setDirection("up") end
    if btnp(1) then self.snake:setDirection("down") end
    if btnp(2) then self.snake:setDirection("left") end
    if btnp(3) then self.snake:setDirection("right") end

    self.snake:update(dt)
    if snakeEatFood(self.snake, self.food) then
        self.snake:grow()
        self.food.row = math.random(0, GRID_HEIGHT - 1)
        self.food.col = math.random(0, GRID_WIDTH - 1)
    end
end
