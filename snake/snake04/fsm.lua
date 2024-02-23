FSM = class()

function FSM:init(states)
  self.states = states or {}
  self.stack = {}
end

function FSM:push(stateName)
  assert(self.states[stateName], stateName.." state don't exist")
  table.insert(self.stack, self.states[stateName]())
end

function FSM:pop()
  table.remove(self.stack)
end

function FSM:clear()
  self.stack = {}
end
