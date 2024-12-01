local move = require("lib.move")
local symbol = require("lib.symbol")
local unmap = require("lib.unmap")
local scope = require("lib.scope")

local M = {
    unmap_all = unmap.all
}

M.char_next = function(n)
    move.search_forward(n)
end
M.char_prev = function(n)
    move.search_backward(n)
end
M.symbol_next = function()
    move.to_char(symbol.symbols(), false, true, 2)
end
M.symbol_prev = function()
    move.to_char_reverse(symbol.symbols(), false, true, 2)
end
M.next = function()
    move.next()
end
M.prev = function()
    move.prev()
end

M.setup = function()
    -- move to matched chars
    vim.keymap.set('n', 'f', function() M.char_next(3) end)
    vim.keymap.set('n', 'F', function() M.char_prev(3) end)
    vim.keymap.set('n', 's', function() M.char_next(2) end)
    vim.keymap.set('n', 'S', function() M.char_prev(2) end)
    vim.keymap.set('n', 't', function() M.char_next(1) end)
    vim.keymap.set('n', 'T', function() M.char_prev(1) end)

    -- move to symbols (language specific semantics)
    vim.keymap.set('n', ']', M.symbol_next)
    vim.keymap.set('n', '[', M.symbol_prev)
    -- unmap all bracket key maps to invoke symbol movement immediately with single key stroke
    M.unmap_all({ '[', ']' }, { 'n' }, 1)

    -- repeat move
    vim.keymap.set('n', ';', M.next)
    vim.keymap.set('n', ',', M.prev)
end

return M
