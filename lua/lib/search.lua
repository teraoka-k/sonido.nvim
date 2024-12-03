local u = require("lib.util")
local v = require("lib.vim")

local function read_lines(start, goes_down, for_each_line)
    local line_number = start
    local last_line = v.line('$')
    while (goes_down and line_number <= last_line) or (not goes_down and line_number >= 1) do
        if for_each_line(v.getline(line_number), line_number) then
            return true
        end
        line_number = line_number + (goes_down and 1 or -1)
    end
end

local M = {
    word_list = { '' },
}

local function is_valid_pos(pos, is_first_line, goes_down)
    if is_first_line then
        local current_pos = v.col('.')
        return goes_down and pos > current_pos or not goes_down and pos < (current_pos)
    end
    return true
end

local function find_word_pos_in_first_line(word, line, goes_down, find)
    local column
    local cursor_pos = v.col('.')
    if goes_down then
        -- search right side of cursor
        column = find(line:sub(cursor_pos + 1, line:len()), word)
        if column then
            column = cursor_pos + column
        end
    else
        -- search left side of cursor
        column = find(line:sub(1, cursor_pos - 1), word)
    end
    return column
end

local function find_word_pos_in_line(word, line, is_first_line, goes_down)
    if not u.is_upper(word) then
        line = line:lower()
    end
    local find = goes_down and u.find_capture or u.find_last_capture
    local column = is_first_line and find_word_pos_in_first_line(word, line, goes_down, find) or
        find(line, word)
    if column and is_valid_pos(column, is_first_line, goes_down) then
        return column
    end
end

local function get_closest(existing_column, new_column, goes_down)
    if existing_column == nil then
        return new_column
    end
    if goes_down then
        return u.min(existing_column, new_column)
    else
        return u.max(existing_column, new_column)
    end
end

function M.search(
    word_list,
    goes_down,
    repeatable
)
    local matched_line = nil
    local matched_column = nil
    local start_line_number = v.line('.')
    read_lines(start_line_number, goes_down, function(line, line_number)
        local found_match = false
        for _, word in ipairs(word_list or M.word_list) do
            local column = find_word_pos_in_line(word, line, line_number == start_line_number, goes_down)
            if column == nil then
                goto continue --continue to the next word
            end
            if repeatable and word_list then
                M.word_list = word_list
            end
            matched_line = line_number
            matched_column = get_closest(matched_column, column, goes_down)
            found_match = true -- stop searching once all words are searched in this line
            ::continue::
        end
        return found_match
    end)
    return matched_line, matched_column
end

return M
