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


function M.search(
    word_list,
    go_back_on_fail,
    go_back,
    goes_down,
    repeatable,
    line_hook,
    match_hook
)
    local start_line_number = v.line('.')
    local matched_line = start_line_number
    local matched_column = v.col('.')
    if not read_lines(start_line_number, goes_down, function(line, line_number)
            local is_upper = u.map(word_list, u.is_upper)
            if line_hook then
                line_hook(line)
            end
            for i, word in ipairs(word_list) do
                if not is_upper[i] then
                    line = line:lower()
                end
                local column = string.find(line, word)
                if column and is_valid_pos(column, line_number, start_line_number, goes_down) then
                    if match_hook and not match_hook() then
                        return false -- continue
                    end
                    if repeatable then
                        M.word = word
                    end
                    matched_line = line_number
                    matched_column = column
                    return true -- break
                end
            end
        end) then
        if go_back_on_fail then
            go_back()
        end
    end
    return matched_line, matched_column
end

return M
