SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager:new(scenes)
    local sm = setmetatable({}, SceneManager)
    sm.scenes = scenes or {}
    sm.stack = {}
    return sm
end

function SceneManager:push(sceneName)
	assert(self.scenes[sceneName], sceneName.." scene dont exists")
    table.insert(self.stack, self.scenes[sceneName]())
end

function SceneManager:pop()
    table.remove(self.stack)
end

function SceneManager:clear()
    self.stack = {}
end

function SceneManager:draw()
    for _, scene in ipairs(self.stack) do
        scene:draw()
    end
end

function SceneManager:update(dt)
    self.stack[#self.stack]:update(dt)
end
