local Game = {}

---@param ped number
---@param position vector3
function Game:faceTo(ped, position)
    local pedCoords = GetEntityCoords(ped)
    local entityCoords = position

    local heading = GetHeadingFromVector_2d(
        entityCoords.x - pedCoords.x,
        entityCoords.y - pedCoords.y
    )

    SetEntityHeading(ped, heading)
end

return Game
