local v = require("lib.vim")
local s = require("lib.search")

local M = {
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

function M.char_next(len)
    M.to_char({ v.get_chars(len) }, true, true, 0)
end

function M.char_prev(len)
    M.to_char_reverse({ v.get_chars(len) }, true, true, 0)
end

function M.next()
    (s.goes_down and M.to_char or M.to_char_reverse)({ s.chars }, false, false, 0)
end

function M.prev()
    (s.goes_down and M.to_char_reverse or M.to_char)({ s.chars }, false, false, 0)
end

function M.to_char(chars_list, searchs_backward_if_not_found, updates_direction, offset)
    s.search(
        chars_list,
        searchs_backward_if_not_found,
        updates_direction,
        function(line) return line <= v.line('$') end, 1,
        function() return 1 end,
        function(char_pos, char_len, char_pos_last) return char_pos + char_len - 1 <= char_pos_last end,
        M.prev,
        true,
        offset
    )
end

function M.to_char_reverse(chars_list, searchs_backward_if_not_found, updates_direction, offset)
    s.search(chars_list, searchs_backward_if_not_found, updates_direction,
        function(line) return line >= 1 end, -1,
        function(line_len, char_len) return line_len - char_len + 1 end,
        function(char_pos, char_len, char_pos_last) return char_pos >= 1 end,
        M.next,
        false,
        offset
    )
end

return M
