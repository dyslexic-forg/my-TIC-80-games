GameScene = {}
GameScene.__index = GameScene

function GameScene:new()
    local scene = setmetatable({}, GameScene)
    scene.snake = Snake:new(GRID_HEIGHT // 2, 3, "right")
    scene.numberOfChoices = 10
    scene.question = newMultiplicationQuestion(scene.numberOfChoices)
    scene.foods = scene:createFoods(scene.numberOfChoices, scene.question.choices)
    scene.score = 0
    return scene
end

function GameScene:draw()
    cls(13)
    for i, food in ipairs(self.foods) do
        food:draw()
    end
    self.snake:draw()
    print("Score: "..self.score, 10, SQUARE_SIZE)
    print(self.question.statement, SCREEN_WIDTH//2 - textWidth(self.question.statement)//2, SQUARE_SIZE)
end

function GameScene:update(dt)
    if btnp(0) then self.snake:setDirection("up") end
    if btnp(1) then self.snake:setDirection("down") end
    if btnp(2) then self.snake:setDirection("left") end
    if btnp(3) then self.snake:setDirection("right") end

    if keyp(48) then GlobalSceneManager:push("pause") end

    self.snake:update(dt)

    for _, food in ipairs(self.foods) do
        if self:snakeEatFood(food) then
            if food.value == self.question.answer then
                self.score = self.score + 1
                self.snake:grow()
                self.question = newMultiplicationQuestion(self.numberOfChoices)
                self.foods = self:createFoods(self.numberOfChoices, self.question.choices)
            else
                GlobalSceneManager:push("gameover")
            end
        end
    end

    if self.snake:bodyCollision() or self.snake:bordersCollision() then
        GlobalSceneManager:push("gameover")
    end
end

function GameScene:snakeEatFood(food)
	return food.row == self.snake.head.row and food.col == self.snake.head.col
end

function GameScene:foodUnderSnake(food)
    for _, s in ipairs(self.snake.segments) do
        if food.row == s.row and food.col == s.col then return true end
    end
    return false
end

function GameScene:createFoods(numberOfFoods, values)
    local foods = {}
    local n = 1
    while n <= numberOfFoods do
        local food = Food:new(math.random(3, GRID_HEIGHT-1), math.random(0, GRID_WIDTH-1), values[n])
        local collision = false
        for i,f in ipairs(foods) do
            if food.row == f.row and food.col == f.col then
                collision = true
                break
            end
        end
        if not (collision or self:foodUnderSnake(food)) then
            table.insert(foods, food)
            n = n + 1
        end
    end
    return foods
end
