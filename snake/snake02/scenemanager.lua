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
    self:pop()
    self:push(sceneName)
end

function SceneManager:push(sceneName)
	assert(self.scenes[sceneName], sceneName.." scene dont exists")
    table.insert(self.stack, self.scenes[sceneName]())
    self.current = self.stack[#self.stack]
end

function SceneManager:pop()
    table.remove(self.stack)
    self.current = self.stack[#self.stack]
end

function SceneManager:draw()
    for _, scene in ipairs(self.stack) do
        scene:draw()
    end
end

function SceneManager:update(dt)
    self.current:update(dt)
end
