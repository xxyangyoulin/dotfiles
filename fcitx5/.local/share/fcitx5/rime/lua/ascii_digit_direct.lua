local M = {}
local K_ACCEPTED = 1
local K_NOOP = 2

local KP_MAP = {
    [0xFFB0] = "0",
    [0xFFB1] = "1",
    [0xFFB2] = "2",
    [0xFFB3] = "3",
    [0xFFB4] = "4",
    [0xFFB5] = "5",
    [0xFFB6] = "6",
    [0xFFB7] = "7",
    [0xFFB8] = "8",
    [0xFFB9] = "9",
}

function M.func(key, env)
    if key:release() or key:ctrl() or key:alt() or key:super() then
        return K_NOOP
    end

    local ctx = env.engine.context

    local digit = nil
    local repr = key:repr() or ""
    if repr:match("^[0-9]$") then
        digit = repr
    else
        digit = KP_MAP[key.keycode]
    end

    if not digit then
        return K_NOOP
    end

    local ascii_mode = ctx:get_option("ascii_mode")
    if ascii_mode then
        if ctx:is_composing() then
            ctx:clear()
        end
    else
        local input = ctx.input or ""
        if ctx:is_composing() or input ~= "" then
            return K_NOOP
        end
    end

    env.engine:commit_text(digit)
    return K_ACCEPTED
end

return M
