local move = require("lib.move")
local symbol = require("lib.symbol")
local unmap = require("lib.unmap")

return {
    unmap_all = unmap.all,
    char_next = move.char_next,
    char_prev = move.char_prev,
    next = move.next,
    prev = move.prev,

    setup = function()
        -- move to matched chars
        vim.keymap.set('n', 's', function() move.char_next(2) end)
        vim.keymap.set('n', 'S', function() move.char_prev(2) end)

        -- move to symbols (language specific semantics)
        symbol.setup()

        -- repeat move
        vim.keymap.set('n', ';', move.next)
        vim.keymap.set('n', ',', move.prev)
    end
}
