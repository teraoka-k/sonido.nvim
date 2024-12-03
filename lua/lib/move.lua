local v = require("lib.vim")
local s = require("lib.search")

local M = {
    godown = true
}

function M.setup()
    vim.keymap.set('n', 'f', function() M.char_next(3) end)
    vim.keymap.set('n', 'F', function() M.char_prev(3) end)
    vim.keymap.set('n', 's', function() M.char_next(2) end)
    vim.keymap.set('n', 'S', function() M.char_prev(2) end)
    vim.keymap.set('n', 't', function() M.char_next(1) end)
    vim.keymap.set('n', 'T', function() M.char_prev(1) end)
    vim.keymap.set('n', ';', function() M.next() end)
    vim.keymap.set('n', ',', function() M.prev() end)
end

local function to_char(len, move)
    local chars = v.get_chars(len)
    if chars ~= '' then
        move({ chars }, true, true, 0, true)
    end
end

function M.char_next(len)
    to_char(len, M.to_char)
end

function M.char_prev(len)
    to_char(len, M.to_char_reverse)
end

function M.next()
    (M.godown and M.to_char or M.to_char_reverse)()
end

function M.prev()
    (M.godown and M.to_char_reverse or M.to_char)()
end

function M._to_char(
    word_list,
    godown,
    repeatable,
    updates_direction,
    goback
)
    local line, column = s.search(
        word_list,
        godown,
        repeatable
    )
    if line and column then
        v.setcursorcharpos(line, column)
    elseif goback then
        goback()
    end
    if updates_direction then
        M.godown = godown
    end
end

function M.to_char(word_list, updates_direction, repeatable, go_back_on_fail)
    M._to_char(
        word_list,
        true,
        repeatable,
        updates_direction,
        go_back_on_fail and M.prev
    )
end

function M.to_char_reverse(word_list, updates_direction, repeatable, go_back_on_fail)
    M._to_char(
        word_list,
        false,
        repeatable,
        updates_direction,
        go_back_on_fail and M.next
    )
end

return M
