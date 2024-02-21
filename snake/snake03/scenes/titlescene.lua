TitleScene = {}
TitleScene.__index = TitleScene

function TitleScene:new()
  local scene = setmetatable({}, TitleScene)
  scene.title = "Snake Game"
  scene.titleWidth = textWidth(scene.title, 2)
  scene.instructions = "press [SPACE] to play"
  scene.instructionsWidth = textWidth(scene.instructions, 1)
  return scene
end

function TitleScene:draw()
  cls(13)
  print(self.title, SCREEN_WIDTH // 2 - self.titleWidth // 2, SCREEN_HEIGHT // 2 - 20, 15, true, 2)
  print(self.instructions, SCREEN_WIDTH // 2 - self.instructionsWidth // 2, SCREEN_HEIGHT // 2, 6, true, 1)
end

function TitleScene:update(dt)
  if keyp(48) then
    GlobalSceneManager:pop()
    GlobalSceneManager:push("play")
    GlobalSceneManager:push("count")
  end
end
