CountDownScene = BaseScene:extend()

function CountDownScene:init()
  self.value = 3
  self.t = 0
end

function CountDownScene:draw()
  print(self.value, SCREEN_WIDTH//2 - textWidth(self.value, 2)//2, SCREEN_HEIGHT//2, 15, false, 2)
end

function CountDownScene:update(dt)
  self.t = self.t + dt
  if self.t >= 1 then
	self.value = self.value - 1
    self.t = 0
    if self.value == 0 then
      GlobalSceneManager:pop()
    end
  end
end
