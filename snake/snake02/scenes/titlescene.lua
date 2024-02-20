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
