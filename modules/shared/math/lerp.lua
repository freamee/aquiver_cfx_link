---@param a number
---@param b number
---@param t number
---@return number
local function lerp(a, b, t)
    t = math.min(math.max(t, 0.0), 1.0)
    return a + (b - a) * t
end


return lerp
