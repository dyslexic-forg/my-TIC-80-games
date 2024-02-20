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
    sm.stack = {}

    return sm
end

function SceneManager:change(sceneName)
    assert(self.scenes[sceneName], sceneName.." scene dont exists")
    self.current = self.scenes[sceneName]()
end

function SceneManager:draw()
    self.current:draw()
end

function SceneManager:update(dt)
    self.current:update(dt)
end
