Snake = {}
Snake.__index = Snake

local offsets = {
  right = {row = 0, col = 1},
  left = {row = 0, col = -1},
  up = {row = -1, col = 0},
  down = {row = 1, col = 0}
}

function Snake:new(row, col, direction, color)
  local s = setmetatable({}, Snake)
  s.direction = direction
  s.color = color or 6
  s.segments = {
    {row = row, col = col},
    {row = row - offsets[direction].row, col = col - offsets[direction].col},
    {row = row - 2*offsets[direction].row, col = col - 2*offsets[direction].col}
  }
  s.speed = SQUARE_SIZE
  s.timer = 0
  s.nextDirections = {}
  return s
end

function Snake:draw()
  for _, s in ipairs(self.segments) do
	rect(s.col * SQUARE_SIZE, s.row * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE, self.color)
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
  for i=#self.segments,2,-1 do
    self.segments[i].row = self.segments[i-1].row
    self.segments[i].col = self.segments[i-1].col
  end
  self.segments[1].row = self.segments[1].row + offsets[self.direction].row
  self.segments[1].col = self.segments[1].col + offsets[self.direction].col
end

function Snake:setDirection(d)
  table.insert(self.nextDirections, d)
end

function Snake:grow()
  table.insert(self.segments, 1, {
    row = self.segments[1].row + offsets[self.direction].row,
    col = self.segments[1].col + offsets[self.direction].col
  })
end

function Snake:getSegmentDirection(idx)
  if idx == 1 then return self.direction
  else
    local offset = {
      row = self.segments[i-1].row - self.segments[i].row,
      col = self.segments[i-1].col - self.segments[i].col
    }
    for d,o in pairs(offsets) do
      if o.row == offset.row and o.col == offset.col then return d end
    end
  end
end
