---@class C_AnimationSequence : OxClass
---@field private _animations C_Animation[]
---@field private _playing boolean
local AnimationSequence = lib.class("C_AnimationSequence")

function AnimationSequence:constructor()
    self._animations = {}
    self._playing = false
end

---@param animation C_Animation
function AnimationSequence:add(animation)
    self._animations[#self._animations + 1] = animation

    return self
end

function AnimationSequence:stop(ped)
    self._playing = false

    if ped and DoesEntityExist(ped) then
        ClearPedTasks(ped)
    end
end

---@param ped number
---@param onComplete? fun()
function AnimationSequence:play(ped, onComplete)
    if self._playing or #self._animations == 0 then
        return false
    end

    self._playing = true

    CreateThread(function()
        for i = 1, #self._animations do
            if not self._playing or not DoesEntityExist(ped) then
                break
            end

            local animation = self._animations[i]
            local dict = animation:getDictionary()

            lib.requestAnimDict(dict)

            if not self._playing then
                break
            end

            TaskPlayAnim(
                ped,
                dict,
                animation:getName(),
                animation:getBlendInSpeed(),
                animation:getBlendOutSpeed(),
                animation:getDuration(),
                animation:getFlag(),
                animation:getPlaybackRate(),
                false,
                false,
                false
            )

            -- if animation:shouldWaitForEnd() then
            --     while self._playing
            --         and DoesEntityExist(ped)
            --         and IsEntityPlayingAnim(
            --             ped,
            --             dict,
            --             animation:getName(),
            --             3
            --         )
            --     do
            --         Wait(0)
            --     end
            -- end
        end

        local completed = self._playing

        self._playing = false

        if completed and onComplete then
            onComplete()
        end
    end)

    return true
end

return AnimationSequence
