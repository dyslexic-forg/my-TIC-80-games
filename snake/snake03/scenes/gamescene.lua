GameScene = {}
GameScene.__index = GameScene

NUMBER_OF_CHOICES = 5

function GameScene:new()
    local scene = setmetatable({}, GameScene)
    scene.snake = Snake:new(GRID_HEIGHT // 2, 3, "right")
    scene.question = newMultiplicationQuestion(NUMBER_OF_CHOICES)
    scene.foods = scene:createFoods()
    scene.score = 0
    return scene
end

function GameScene:draw()
    map()
    for i, food in ipairs(self.foods) do
        food:draw()
    end
    self.snake:draw()
    print("Score: "..self.score, 10, SQUARE_SIZE//2)
    print(self.question.statement, SCREEN_WIDTH//2 - textWidth(self.question.statement)//2, SQUARE_SIZE//2)
    self:drawChoices()
end

function GameScene:drawChoices()
    for i,choice in ipairs(self.question.choices) do
        local x = self.foods[i].col * SQUARE_SIZE + SQUARE_SIZE// 2 - textWidth(choice, 1)//2 + 2
        local y = (self.foods[i].row - 1) * SQUARE_SIZE + 1
        print(choice, x, y, 15, true, 1, true)
    end
end

function GameScene:update(dt)
    if btnp(0) then self.snake:setDirection("up") end
    if btnp(1) then self.snake:setDirection("down") end
    if btnp(2) then self.snake:setDirection("left") end
    if btnp(3) then self.snake:setDirection("right") end

    if keyp(48) then GlobalSceneManager:push("pause") end

    self.snake:update(dt)

    for i, food in ipairs(self.foods) do
        if self:snakeEatFood(food) then
            if self.question.choices[i] == self.question.answer then
                self.score = self.score + 1
                self.snake.speed = self.snake.speed + 0.2
                self.snake:grow()
                self.question = newMultiplicationQuestion(NUMBER_OF_CHOICES)
                self.foods = self:createFoods()
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

function GameScene:createFoods()
    local foods = {}
    local n = 1
    while n <= NUMBER_OF_CHOICES do
        local food = Food:new(math.random(2, GRID_HEIGHT-2), math.random(1, GRID_WIDTH-2), self.question.choices[n])
        local collision = false
        for _,f in ipairs(foods) do
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
