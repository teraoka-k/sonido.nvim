local v = require("lib.vim")
local s = require("lib.search")

local M = {
    is_down = true
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
    (M.is_down and M.to_char or M.to_char_reverse)({ s.word }, false, false, false)
end

function M.prev()
    (M.is_down and M.to_char_reverse or M.to_char)({ s.word }, false, false, false)
end

function M._to_char(go_back, is_down, chars_list, searchs_backward_if_not_found, updates_direction, repeatable)
    local line, column = s.search(
        chars_list,
        searchs_backward_if_not_found,
        go_back,
        is_down,
        repeatable
    )
    v.setcursorcharpos(line, column)
    if updates_direction then
        M.is_down = is_down
    end
end

function M.to_char(word_list, go_back_on_fail, updates_direction, repeatable)
    M._to_char(M.prev, true, word_list, go_back_on_fail, updates_direction, repeatable)
end

function M.to_char_reverse(word_list, go_back_on_fail, updates_direction, repeatable)
    M._to_char(M.next, false, word_list, go_back_on_fail, updates_direction, repeatable)
end

return M
