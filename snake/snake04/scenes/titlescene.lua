TitleScene = BaseScene:extend()

function TitleScene:init()
  self.title = "Snake Game"
  self.titleWidth = textWidth(self.title, 2)
  self.instructions = "press [ENTER] to play"
  self.instructionsWidth = textWidth(self.instructions, 1)
end

function TitleScene:draw()
  map()
  print(self.title, SCREEN_WIDTH // 2 - self.titleWidth // 2, SCREEN_HEIGHT // 2 - 20, 15, true, 2)
  print(self.instructions, SCREEN_WIDTH // 2 - self.instructionsWidth // 2, SCREEN_HEIGHT // 2, 15, true, 1)
end

function TitleScene:update(dt)
  local x, y, left = mouse()
  if keyp(50) or left then
    GlobalSceneManager:pop()
    GlobalSceneManager:push("play")
    GlobalSceneManager:push("count")
  end
end
