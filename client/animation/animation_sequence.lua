---@class C_AnimationSequence : OxClass
---@field private _animations C_Animation[]
---@field private _playing boolean
---@field private _run table?
---@field private _ped number?
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

---@param ped? number Defaults to the ped used for playback.
function AnimationSequence:stop(ped)
    self._run = nil
    self._playing = false
    ped = ped or self._ped
    self._ped = nil

    if ped and DoesEntityExist(ped) then
        ClearPedTasks(ped)
    end
end

function AnimationSequence:isPlaying()
    return self._playing
end

---@param ped number
---@param onComplete? fun()
function AnimationSequence:play(ped, onComplete)
    if self._playing or #self._animations == 0 or not DoesEntityExist(ped) then
        return false
    end

    self._playing = true
    self._ped = ped

    local run = {}
    self._run = run

    local function cancelled()
        return self._run ~= run or not DoesEntityExist(ped)
    end

    CreateThread(function()
        local completed = true

        for i = 1, #self._animations do
            if cancelled() then
                completed = false
                break
            end

            local animation = self._animations[i]
            local waitForFinish = animation:getWaitForFinish()
            local duration = animation:getDuration()
            local flag = animation:getFlag()

            -- An untimed waiting step plays once; timed loops keep their flag.
            if waitForFinish and duration < 0 then
                flag = flag - flag % 2
            end

            local started, startedAt = animation:play(ped, cancelled, flag)

            if not started or cancelled() then
                completed = false
                break
            end

            if waitForFinish then
                local dict = animation:getDictionary()
                local name = animation:getName()

                while not cancelled() and IsEntityPlayingAnim(ped, dict, name, 3) do
                    if duration >= 0 and GetGameTimer() - startedAt >= duration then
                        break
                    end

                    if duration < 0 and HasEntityAnimFinished(ped, dict, name, 3) then
                        break
                    end

                    Citizen.Wait(0)
                end

                if cancelled() then
                    completed = false
                    break
                end
            end
        end

        -- A stopped run must leave a newer run and its callback untouched.
        if self._run ~= run then
            return
        end

        self._run = nil
        self._playing = false

        if completed and onComplete then
            onComplete()
        end
    end)

    return true
end

return AnimationSequence
