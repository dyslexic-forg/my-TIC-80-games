PauseScene = {}
PauseScene.__index = PauseScene

function PauseScene:new()
  return setmetatable({}, PauseScene)
end

function PauseScene:draw() end

function PauseScene:update(dt)
  if keyp(48) then
    GlobalSceneManager:pop()
  end
end
