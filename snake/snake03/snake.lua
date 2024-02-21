Snake = {}
Snake.__index = Snake

SMOOTH_MOVEMENT = true

local offsets = {
  right = {row = 0, col = 1},
  left = {row = 0, col = -1},
  up = {row = -1, col = 0},
  down = {row = 1, col = 0}
}

local directionToRotation = {
  right = 0,
  down = 1,
  left = 2,
  up = 3
}

local directionToFlip = {
  right = 0,
  up = 0,
  left = 2,
  down = 1
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
    {row = row - 2*offsets[direction].row, col = col - 2*offsets[direction].col},
  }
  s.size = 3
  s.speed = SQUARE_SIZE
  s.timer = 0
  s.nextDirections = {}
  return s
end

function Snake:draw()
  for i, s in ipairs(self.segments) do
    local currentX = s.col * SQUARE_SIZE
    local currentY = s.row * SQUARE_SIZE

    local x, y
    if SMOOTH_MOVEMENT then
      local nextX = (s.col + offsets[self:getSegmentDirection(i)].col) * SQUARE_SIZE
      local nextY = (s.row + offsets[self:getSegmentDirection(i)].row) * SQUARE_SIZE
      x = interpolate(currentX, nextX, self.timer * self.speed)
      y = interpolate(currentY, nextY, self.timer * self.speed)
    else
      x = currentX
      y = currentY
    end
    local d = self:getSegmentDirection(i)
    spr(self:getSegmentSprite(i), x, y, 0, 1, directionToFlip[d], directionToRotation[d])

    if i > 1 and i < #self.segments then
      spr(self:getSegmentSprite(i), currentX, currentY, 0, 1, directionToFlip[d], directionToRotation[d])
    end
  end
end

function Snake:getSegmentSprite(idx)
  if idx == 1 then return 3
  elseif idx == self.size then return 1
  else return 2
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

function Snake:bodyCollision()
  for i,s in ipairs(self.segments) do
    if i ~= 1 and self.head.row == s.row and self.head.col == s.col then
      return true
    end
  end
  return false
end

function Snake:bordersCollision()
  return self.head.row < 2 or self.head.row > GRID_HEIGHT - 2 or self.head.col < 1 or self.head.col > GRID_WIDTH - 2
end
