PauseScene = BaseScene:extend()

function PauseScene:init()
  self.msg = "paused"
end

function PauseScene:draw()
  print(self.msg, SCREEN_WIDTH - textWidth(self.msg) - 3, SCREEN_HEIGHT - SQUARE_SIZE)
end

function PauseScene:update(dt)
  if keyp(48) then
    GlobalSceneManager:pop()
  end
end
