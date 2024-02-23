SceneManager = FSM:extend()

function SceneManager:draw()
    for _, scene in ipairs(self.stack) do
        scene:draw()
    end
end

function SceneManager:update(dt)
    self.stack[#self.stack]:update(dt)
end
