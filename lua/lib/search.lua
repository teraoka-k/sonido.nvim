local u = require("lib.util")
local v = require("lib.vim")

local M = {
    chars = '',
    goes_down = true,
}

function M.search(
    chars_list, searchs_backward_if_not_found, updates_direction,
    if_line_exists, d, default_char_pos,
    if_char_exists,
    search_backwards,
    goes_down,
    offset,
    repeatable
)
    local line_number_current = v.line('.')
    local line_number = line_number_current
    local chars_len_list = u.map(chars_list, function(chars) return chars:len() end)
    local chars_lower_list = u.map(chars_list, function(chars) return chars:lower() end)

    while if_line_exists(line_number) do
        for i, chars in ipairs(chars_list) do
            local chars_len = chars_len_list[i]
            local chars_lower = chars_lower_list[i]

            --read line
            local line_chars = v.getline(line_number):lower()
            local char_pos = line_number == line_number_current and (v.col('.') + d + (goes_down and 0 or -offset)) or
                default_char_pos(line_chars:len(), chars_len);
            local char_pos_last = line_chars:len()

            --try to focus to the char in the line
            while if_char_exists(char_pos, chars_len, char_pos_last) do
                if line_chars:sub(char_pos, char_pos + chars_len - 1) == chars_lower then
                    v.setcursorcharpos(line_number, char_pos + offset)
                    if repeatable then
                        M.chars = chars_lower
                    end
                    if updates_direction then
                        M.goes_down = goes_down
                    end
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

return M
