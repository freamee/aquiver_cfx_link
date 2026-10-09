---@class Color : OxClass
---@field protected _r number
---@field protected _g number
---@field protected _b number
---@field protected _a number
local Color = lib.class('Color')

---@param value number
---@return number
local function validateChannel(value)
    assert(type(value) == 'number', 'Color channel must be a number')
    assert(value % 1 == 0 and value >= 0 and value <= 255,
        'Color channel must be an integer between 0 and 255')

    return value
end

---@param r number
---@param g number
---@param b number
---@param a? number
function Color:constructor(r, g, b, a)
    self._r = validateChannel(r)
    self._g = validateChannel(g)
    self._b = validateChannel(b)
    self._a = validateChannel(a or 255)
end

---@return number
function Color:getR()
    return self._r
end

---@return number
function Color:getG()
    return self._g
end

---@return number
function Color:getB()
    return self._b
end

---@return number
function Color:getA()
    return self._a
end

---@param r number
function Color:setR(r)
    self._r = validateChannel(r)
end

---@param g number
function Color:setG(g)
    self._g = validateChannel(g)
end

---@param b number
function Color:setB(b)
    self._b = validateChannel(b)
end

---@param a number
function Color:setA(a)
    self._a = validateChannel(a)
end

---@return table
function Color:serialize()
    return {
        r = self._r,
        g = self._g,
        b = self._b,
        a = self._a
    }
end

---@param includeAlpha? boolean
---@return string
function Color:toHex(includeAlpha)
    if includeAlpha then
        return ('#%02X%02X%02X%02X'):format(
            self._r, self._g, self._b, self._a
        )
    end

    return ('#%02X%02X%02X'):format(
        self._r, self._g, self._b
    )
end

---@return string
function Color:toRGB()
    return ('rgb(%d, %d, %d)'):format(
        self._r, self._g, self._b
    )
end

---@return string
function Color:toRGBA()
    return ('rgba(%d, %d, %d, %.3f)'):format(
        self._r, self._g, self._b, self._a / 255
    )
end

---@return Color
function Color:clone()
    return Color:new(self._r, self._g, self._b, self._a)
end

---@param hex string
---@return Color
function Color.fromHex(hex)
    assert(type(hex) == 'string', 'Hex color must be a string')

    hex = hex:gsub('^#', '')

    assert(
        #hex == 3 or #hex == 4 or #hex == 6 or #hex == 8,
        'Hex color must use RGB, RGBA, RRGGBB or RRGGBBAA format'
    )

    assert(hex:match('^%x+$'), 'Invalid hex color')

    if #hex == 3 or #hex == 4 then
        hex = hex:gsub('.', '%0%0')
    end

    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    local a = #hex == 8 and tonumber(hex:sub(7, 8), 16) or 255

    return Color:new(r, g, b, a)
end

return Color
