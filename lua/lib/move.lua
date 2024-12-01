local function map(array, fn)
    local new_map = {}
    for i, element in ipairs(array) do
        table.insert(new_map, fn(element))
    end
    return new_map
end

local M = {
    --state
    chars = '',
    goes_down = true,
    --functiosn
    col = vim.fn.col,
    getline = vim.fn.getline,
    get_visible_first_line = function() return vim.fn.getpos('w0')[2] end,
    get_visible_last_line = function() return vim.fn.getpos('w$')[2] end,
    getpos = vim.fn.getpos,
    line = vim.fn.line,
    setcursorcharpos = vim.fn.setcursorcharpos,
    _read_char = function() return vim.fn.nr2char(vim.fn.getchar()) end
}

function M.setup()
    vim.keymap.set('n', 'f', function() M.search_forward(3) end)
    vim.keymap.set('n', 'F', function() M.search_backward(3) end)
    vim.keymap.set('n', 's', function() M.search_forward(2) end)
    vim.keymap.set('n', 'S', function() M.search_backward(2) end)
    vim.keymap.set('n', 't', function() M.search_forward(1) end)
    vim.keymap.set('n', 'T', function() M.search_backward(1) end)
    vim.keymap.set('n', ';', function() M.next() end)
    vim.keymap.set('n', ',', function() M.prev() end)
end

function M.search_forward(len)
    M.to_char({ M.get_chars(len) }, true, true, 0)
end

function M.search_backward(len)
    M.to_char_reverse({ M.get_chars(len) }, true, true, 0)
end

function M.next()
    (M.goes_down and M.to_char or M.to_char_reverse)({ M.chars }, false, false, 0)
end

function M.prev()
    (M.goes_down and M.to_char_reverse or M.to_char)({ M.chars }, false, false, 0)
end

function M.get_chars(char_len)
    if char_len < 1 then
        return M.chars
    else
        local chars = ""
        for i = 1, char_len do
            local char = M._read_char()
            chars = chars .. char
        end
        return chars
    end
end

function M._to_char(
    chars_list, searchs_backward_if_not_found, updates_direction,
    if_line_exists, d, default_char_pos,
    if_char_exists,
    search_backwards,
    goes_down,
    offset
)
    local line_number_current = M.line('.')
    local line_number = line_number_current
    local chars_len_list = map(chars_list, function(chars) return string.len(chars) end)
    local chars_lower_list = map(chars_list, function(chars) return chars:lower() end)

    while if_line_exists(line_number) do
        for i, chars in ipairs(chars_list) do
            local chars_len = chars_len_list[i]
            local chars_lower = chars_lower_list[i]

            --read line
            local line_chars = M.getline(line_number):lower()
            local char_pos = line_number == line_number_current and (M.col('.') + d - offset) or
                default_char_pos(string.len(line_chars), chars_len);
            local char_pos_last = string.len(line_chars)

            --try to focus to the char in the line
            while if_char_exists(char_pos, chars_len, char_pos_last) do
                if line_chars:sub(char_pos, char_pos + chars_len - 1) == chars_lower then
                    M.setcursorcharpos(line_number, char_pos + offset)
                    M.chars = chars_lower
                    return
                end
                char_pos = char_pos + d
            end
        end

        line_number = line_number + d
    end

    if searchs_backward_if_not_found then
        search_backwards()
    end

    if updates_direction then
        M.goes_down = goes_down
    end
end

function M.to_char(chars_list, searchs_backward_if_not_found, updates_direction, offset)
    M._to_char(
        chars_list,
        searchs_backward_if_not_found,
        updates_direction,
        function(line) return line <= M.line('$') end, 1,
        function() return 1 end,
        function(char_pos, char_len, char_pos_last) return char_pos + char_len - 1 <= char_pos_last end,
        M.prev,
        true,
        offset
    )
end

function M.to_char_reverse(chars_list, searchs_backward_if_not_found, updates_direction, offset)
    M._to_char(chars_list, searchs_backward_if_not_found, updates_direction,
        function(line) return line >= 1 end, -1,
        function(line_len, char_len) return line_len - char_len + 1 end,
        function(char_pos, char_len, char_pos_last) return char_pos >= 1 end,
        M.next,
        false,
        offset
    )
end

return M
