return {
    set = function(newState)
        return exports.aquiver_cfx:SetCursorState(newState)
    end,

    get = function(_)
        return exports.aquiver_cfx['Cursor:get']()
    end,

    toggle = function(_)
        return exports.aquiver_cfx['Cursor:toggle']()
    end,

    force = function(_, state)
        return exports.aquiver_cfx['Cursor:force'](state)
    end
}
