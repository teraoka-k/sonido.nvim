local u = require("lib.util")

return {
    symbols = function()
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
}
