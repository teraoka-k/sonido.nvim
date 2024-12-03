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
    word = '',
}

local function is_valid_pos(pos, line_number, start_line_number, goes_down)
    if line_number == start_line_number then
        local current_pos = v.col('.')
        return goes_down and pos > current_pos or not goes_down and pos < (current_pos)
    end
    return true
end

local function find_word_pos_in_line(word, line, line_number, start_line_number, goes_down)
    if not u.is_upper(word) then
        line = line:lower()
    end
    local column = string.find(line, word)
    if column and is_valid_pos(column, line_number, start_line_number, goes_down) then
        return column
    end
end

-- use hooks to add extensions and customize match conditions
-- - hooks.line: (i: int, content: str) -> ()
--   - called for each line. return true to stop searching
-- - hooks.:match (line: str, column: int) -> bool
--   - return true for pass, false to ignore this matched position
function M.search(
    word_list,
    goes_down,
    repeatable,
    hooks
)
    local matched_line = nil
    local matched_column = nil
    local start_line_number = v.line('.')
    read_lines(start_line_number, goes_down, function(line, line_number)
        if hooks and hooks.line then
            local result = hooks.line(line_number, line)
            if result ~= nil and result then
                return true -- stop searching
            end
        end
        for _, word in ipairs(word_list) do
            local column = find_word_pos_in_line(word, line, line_number, start_line_number, goes_down)
            if column == nil or column and hooks and hooks.match and not hooks.match(line, column) then
                goto continue --continue to the next word
            end
            if repeatable then
                M.word = word
            end
            matched_line = line_number
            matched_column = column
            do return true end -- stop searching
            ::continue::
        end
    end)
    return matched_line, matched_column
end

return M
