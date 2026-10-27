local Cursor = {}
Cursor._currentState = false
Cursor._forceState = false
Cursor._tickState = false

---@param newState boolean
function Cursor:set(newState)
    self._currentState = newState

    if self._currentState then
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)

        if not self._tickState then
            self._tickState = true

            Citizen.CreateThread(function()
                while self._tickState do
                    -- DisableAllControlActions(0)

                    -- Camera
                    DisableControlAction(0, 1, true) -- Look Left/Right
                    DisableControlAction(0, 2, true) -- Look Up/Down

                    -- Combat
                    DisableControlAction(0, 24, true)  -- Attack
                    DisableControlAction(0, 25, true)  -- Aim
                    DisableControlAction(0, 37, true)  -- Weapon wheel
                    DisableControlAction(0, 45, true)  -- Reload
                    DisableControlAction(0, 69, true)  -- Vehicle attack
                    DisableControlAction(0, 70, true)  -- Vehicle attack 2
                    DisableControlAction(0, 92, true)  -- Passenger attack
                    DisableControlAction(0, 140, true) -- Melee light
                    DisableControlAction(0, 141, true) -- Melee heavy
                    DisableControlAction(0, 142, true) -- Melee alternate
                    DisableControlAction(0, 257, true) -- Attack 2
                    DisableControlAction(0, 263, true) -- Melee attack 1
                    DisableControlAction(0, 264, true) -- Melee attack 2

                    -- Movement actions
                    DisableControlAction(0, 21, true) -- Sprint
                    DisableControlAction(0, 22, true) -- Jump
                    DisableControlAction(0, 36, true) -- Duck
                    DisableControlAction(0, 44, true) -- Cover

                    -- Interaction
                    DisableControlAction(0, 23, true) -- Enter vehicle
                    DisableControlAction(0, 75, true) -- Exit vehicle

                    -- EnableControlAction(0, 30, true)
                    -- EnableControlAction(0, 31, true)

                    Citizen.Wait(0)
                end
            end)
        end
    else
        self._tickState = false

        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end

function Cursor:get()
    return self._currentState
end

function Cursor:toggle()
    self:set(not self._currentState)
end

---@param forceState boolean
function Cursor:force(forceState)
    self._forceState = forceState
end

RegisterCommand("TOGGLE_CURSOR_STATE", function()
    Cursor:toggle()
end, false)

RegisterKeyMapping("TOGGLE_CURSOR_STATE", "Cursor", "keyboard", "m")

return Cursor
