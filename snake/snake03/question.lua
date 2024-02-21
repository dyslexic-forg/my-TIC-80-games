local function hasValue(tab, value)
    for i, v in ipairs(tab) do
        if v == value then return i end
    end
    return false
end

function newMultiplicationQuestion(numberOfChoices)
    local numberOfChoices = numberOfChoices or 5
    local a = math.random(0, 10)
    local b = math.random(0, 10)
    local answer = a * b
    local choices = {answer}
    while #choices < numberOfChoices do
        local c = math.random(0, 100)
        if not hasValue(choices, c) then
            table.insert(choices, c)
        end
    end
    return { statement = a.." x "..b, choices = choices, answer = answer}
end
