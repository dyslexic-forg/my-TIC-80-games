GameOverScene = BaseScene:extend()

function GameOverScene:init()
  self.title = "Gamer Over"
  self.titleWidth = textWidth(self.title, 2)
  self.instructions = "press [ENTER] to play again"
  self.instructionsWidth = textWidth(self.instructions, 1)
end

function GameOverScene:draw()
  print(self.title, SCREEN_WIDTH // 2 - self.titleWidth // 2, SCREEN_HEIGHT // 2 - 20, 15, true, 2)
  print(self.instructions, SCREEN_WIDTH // 2 - self.instructionsWidth // 2, SCREEN_HEIGHT // 2, 15, true, 1)
end

function GameOverScene:update(dt)
  local x, y, left = mouse()
  if keyp(50) or left then
    GlobalSceneManager:clear()
    GlobalSceneManager:push("play")
    GlobalSceneManager:push("count")
  end
end
