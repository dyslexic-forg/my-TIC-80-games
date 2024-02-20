SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager:new(scenes)
    local sm = setmetatable({}, SceneManager)
    sm.empty = {
        draw = function() end,
        update = function() end
    }
    sm.scenes = scenes or {}
    sm.current = sm.empty

    return sm
end

function SceneManager:change(sceneName)
    self.current = self.scenes[sceneName]()
end

function SceneManager:draw()
    self.current:draw()
end

function SceneManager:update(dt)
    self.current:update(dt)
end