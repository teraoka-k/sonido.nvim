local move = require("lib.move")
local symbol = require("lib.symbol")
local unmap = require("lib.unmap")
-- local scope = require("lib.scope")

return {
    unmap_all = unmap.all,
    char_next = move.char_next,
    char_prev = move.char_prev,
    symbol_next = symbol.next,
    symbol_prev = symbol.prev,
    next = move.next,
    prev = move.prev,

    setup = function()
        -- move to matched chars
        vim.keymap.set('n', 'f', function() move.char_next(3) end)
        vim.keymap.set('n', 'F', function() move.char_prev(3) end)
        vim.keymap.set('n', 's', function() move.char_next(2) end)
        vim.keymap.set('n', 'S', function() move.char_prev(2) end)
        vim.keymap.set('n', 't', function() move.char_next(1) end)
        vim.keymap.set('n', 'T', function() move.char_prev(1) end)

        -- move to symbols (language specific semantics)
        vim.keymap.set('n', ']', symbol.next)
        vim.keymap.set('n', '[', symbol.prev)
        -- unmap all bracket key maps to invoke symbol movement immediately with single key stroke
        unmap.all({ '[', ']' }, { 'n' }, 1)

        -- repeat move
        vim.keymap.set('n', ';', move.next)
        vim.keymap.set('n', ',', move.prev)
    end
}
