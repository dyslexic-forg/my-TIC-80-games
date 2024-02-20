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
