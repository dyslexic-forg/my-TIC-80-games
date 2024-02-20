
---------------------------------------------------------
----------------Auto generated code block----------------
---------------------------------------------------------

do
    local searchers = package.searchers or package.loaders
    local origin_seacher = searchers[2]
    searchers[2] = function(path)
        local files =
        {
------------------------
-- Modules part begin --
------------------------

["snake"] = function()
--------------------
-- Module: 'snake'
--------------------
Snake = {}
Snake.__index = Snake

SMOOTH_MOVEMENT = true

local offsets = {
  right = {row = 0, col = 1},
  left = {row = 0, col = -1},
  up = {row = -1, col = 0},
  down = {row = 1, col = 0}
}

local function interpolate(a, b, t)
  return a + (b - a) * t
end

function Snake:new(row, col, direction, color)
  local s = setmetatable({}, Snake)
  s.direction = direction
  s.color = color or 6
  self.head = {row = row, col = col}
  s.segments = {
    self.head,
    {row = row - offsets[direction].row, col = col - offsets[direction].col},
    {row = row - 2*offsets[direction].row, col = col - 2*offsets[direction].col}
  }
  s.size = 3
  s.speed = SQUARE_SIZE
  s.timer = 0
  s.nextDirections = {}
  return s
end

function Snake:draw()
  if SMOOTH_MOVEMENT then
    for i, s in ipairs(self.segments) do
      local currentX = s.col * SQUARE_SIZE
      local currentY = s.row * SQUARE_SIZE
      local nextX = (s.col + offsets[self:getSegmentDirection(i)].col) * SQUARE_SIZE
      local nextY = (s.row + offsets[self:getSegmentDirection(i)].row) * SQUARE_SIZE
      rect(
        interpolate(currentX, nextX, self.timer * self.speed),
        interpolate(currentY, nextY, self.timer * self.speed),
        SQUARE_SIZE, SQUARE_SIZE, self.color
      )
      if self:segmentInCurve(i) then
        rect(currentX, currentY, SQUARE_SIZE, SQUARE_SIZE, self.color)
        print(self:segmentInCurve(i), currentX, currentY)
      end
    end
  else
    for _, s in ipairs(self.segments) do
      rect(s.col * SQUARE_SIZE, s.row * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE, self.color)
    end
  end
end

local function opositeDirection(d)
  if d == "right" then return "left"
  elseif d == "left" then return "right"
  elseif d == "up" then return "down"
  else return "up"
  end
end

function Snake:update(dt)
  self.timer = self.timer + dt
  if self.timer >= 1/self.speed then
	self:move()
    self.timer = 0
    if #self.nextDirections > 0 then
      local d = table.remove(self.nextDirections, 1)
      if d ~= opositeDirection(self.direction) then
        self.direction = d
      end
    end
  end
end

function Snake:move()
  for i=self.size,2,-1 do
    self.segments[i].row = self.segments[i-1].row
    self.segments[i].col = self.segments[i-1].col
  end
  self.head.row = self.head.row + offsets[self.direction].row
  self.head.col = self.head.col + offsets[self.direction].col
end

function Snake:setDirection(d)
  table.insert(self.nextDirections, d)
end

function Snake:grow()
  local lastDirection = self:getSegmentDirection(self.size)
  table.insert(self.segments, self.size + 1, {
    row = self.segments[self.size].row - offsets[lastDirection].row,
    col = self.segments[self.size].col - offsets[lastDirection].col
  })
  self.size = self.size + 1
end

function Snake:getSegmentDirection(idx)
  if idx == 1 then return self.direction
  else
    local offset = {
      row = self.segments[idx-1].row - self.segments[idx].row,
      col = self.segments[idx-1].col - self.segments[idx].col
    }
    for d,o in pairs(offsets) do
      if o.row == offset.row and o.col == offset.col then return d end
    end
  end
end

function Snake:segmentInCurve(idx)
  if idx > 1 and idx < self.size then
    local direction = self:getSegmentDirection(idx)
    local previousDirection = self:getSegmentDirection(idx + 1)
    if (direction == "right" and previousDirection == "up") or (direction == "down" and previousDirection == "left") then return 0
    elseif (direction == "left" and previousDirection == "up") or (direction == "down" and previousDirection == "right") then return 1
    elseif (direction == "left" and previousDirection == "down") or (direction == "up" and previousDirection == "right") then return 2
    elseif (direction == "up" and previousDirection == "left") or (direction == "right" and previousDirection == "down") then return 3
    end
  end
  return false
end

end,

["food"] = function()
--------------------
-- Module: 'food'
--------------------
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

end,

["scenemanager"] = function()
--------------------
-- Module: 'scenemanager'
--------------------
SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager:new(scenes)
    local sm = setmetatable({}, SceneManager)
    sm.empty = {
        draw = function() end,
        update = function() end
    }
    sm.scenes = scenes or {}
    sm.current = sm.empty

    return sm
end

function SceneManager:change(sceneName)
    assert(self.scenes[sceneName], sceneName.." scene dont exists")
    self.current = self.scenes[sceneName]()
end

function SceneManager:draw()
    self.current:draw()
end

function SceneManager:update(dt)
    self.current:update(dt)
end

end,

["scenes.titlescene"] = function()
--------------------
-- Module: 'scenes.titlescene'
--------------------
TitleScene = {}
TitleScene.__index = TitleScene

function TitleScene:new()
  return setmetatable({}, TitleScene)
end

function TitleScene:draw()
  cls(13)
  print("Snake Game")
end

function TitleScene:update(dt)
  if keyp(48) then GlobalSceneManager:change("play") end
end

end,

["scenes.gamescene"] = function()
--------------------
-- Module: 'scenes.gamescene'
--------------------
require "../snake"
require "../food"

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

end,

----------------------
-- Modules part end --
----------------------
        }
        if files[path] then
            return files[path]
        else
            return origin_seacher(path)
        end
    end
end
---------------------------------------------------------
----------------Auto generated code block----------------
---------------------------------------------------------
-- title:   snake
-- author:  danilo
-- desc:    a simple snake game
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

require "scenes/gamescene"
require "scenes/titlescene"
require "scenemanager"

-- constants
SCREEN_WIDTH = 240
SCREEN_HEIGHT = 136
SQUARE_SIZE = 8
GRID_WIDTH = SCREEN_WIDTH // SQUARE_SIZE
GRID_HEIGHT = SCREEN_HEIGHT // SQUARE_SIZE

GlobalSceneManager = SceneManager:new({
		["play"] = function() return GameScene:new() end,
		["title"] = function() return TitleScene:new() end,
})

GlobalSceneManager:change("title")

function TIC()
	GlobalSceneManager:update(1/60)
	GlobalSceneManager:draw()
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>
