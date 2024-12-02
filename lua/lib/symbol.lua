local u = require("lib.util")
local m = require("lib.move")

local function symbols()
    local file = vim.fn.expand('%')
    if u.endswith(file, "rs") then
        return { "fn ", "struct ", "impl ", "trait " }
    elseif u.endswith(file, "lua") then
        return { "function(", "function " }
    elseif u.endswith(file, "md") then
        return { "# " }
    end
    return { "function " }
end

return {
    next = function()
        m.to_char(symbols(), false, true, 2)
    end,
    prev = function()
        m.to_char_reverse(symbols(), false, true, 2)
    end,
}
