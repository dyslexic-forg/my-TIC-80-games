GameScene = {}
GameScene.__index = GameScene

function GameScene:new()
    local scene = setmetatable({}, GameScene)
    scene.snake = Snake:new(GRID_HEIGHT // 2, 3, "right")
    scene.food = Food:new(GRID_HEIGHT // 2, GRID_WIDTH // 2)
    self.score = 0
    return scene
end

function GameScene:draw()
    cls(13)
    self.food:draw()
    self.snake:draw()
    print("Score: "..self.score, 10, 10)
end

function GameScene:update(dt)
    if btnp(0) then self.snake:setDirection("up") end
    if btnp(1) then self.snake:setDirection("down") end
    if btnp(2) then self.snake:setDirection("left") end
    if btnp(3) then self.snake:setDirection("right") end

    if keyp(48) then GlobalSceneManager:push("pause") end

    self.snake:update(dt)
    if self:snakeEatFood() then
        self.snake:grow()
        self:resetFoodPosition()
        self.score = self.score + 1
    end
    if self.snake:bodyCollision() or self.snake:bordersCollision() then
        GlobalSceneManager:change("gameover")
    end
end

function GameScene:snakeEatFood()
	return self.food.row == self.snake.head.row and self.food.col == self.snake.head.col
end

function GameScene:foodUnderSnake()
    for _, s in ipairs(self.snake.segments) do
        if self.food.row == s.row and self.food.col == s.col then return true end
    end
    return false
end

function GameScene:resetFoodPosition()
    while true do
        self.food.row = math.random(0, GRID_HEIGHT - 1)
        self.food.col = math.random(0, GRID_WIDTH - 1)
        if not self:foodUnderSnake() then
            return
        end
    end
end
