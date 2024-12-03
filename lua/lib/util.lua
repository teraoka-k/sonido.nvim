local function escape_pattern_symbols(str)
    local escape = str:gsub('%%', '%%%%')
    for _, char in ipairs({ '(', ')', '[', ']', '.', '*', '?', '+', '-', '^', '$' }) do
        escape = escape:gsub('%' .. char, '%%' .. char)
    end
    return escape
end
escape_pattern_symbols('() [] ^$ +- *?.')
local function find_capture(str, pattern)
    local start_at, end_at, capture = string.find(str, pattern)
    if not capture then
        return start_at, end_at, capture
    end
    print(pattern, capture)
    if start_at then
        return (start_at + string.find(str:sub(start_at), escape_pattern_symbols(capture)) - 1), end_at, capture
    end
end

local function find_captures(str, pattern)
    local match_list = {}
    local start_at = 1
    while true do
        local _start_at, end_at, _ = find_capture(str, pattern)
        if end_at == nil then
            break
        end
        table.insert(match_list, start_at + _start_at - 1)
        str = str:sub(end_at + 1)
        start_at = start_at + end_at
    end
    return match_list
end

local M = {
    -- array
    contains = function(char, chars)
        for i, _char in ipairs(chars) do
            if _char == char then
                return true
            end
        end
        return false
    end,

    map = function(array, fn)
        local new_map = {}
        if not array then return new_map end
        for _, element in ipairs(array) do
            table.insert(new_map, fn(element))
        end
        return new_map
    end,
    merge = function(arr1, arr2)
        local arr = {}
        for _, v in ipairs(arr1) do
            table.insert(arr, v)
        end
        for _, v in ipairs(arr2) do
            table.insert(arr, v)
        end
        return arr
    end,
    -- table
    keys = function(t)
        local v_list = {}
        for k, _ in next, t, nil do
            table.insert(v_list, k)
        end
        return v_list
    end,
    values = function(t)
        local v_list = {}
        for _, v in next, t, nil do
            table.insert(v_list, v)
        end
        return v_list
    end,
    -- string
    endswith = function(str, ending)
        return str:sub(- #ending) == ending
    end,
    is_upper = function(str)
        return string.find(str, '%u') ~= nil
    end,
    find_capture = find_capture,
    find_captures = find_captures,
    find_last_capture = function(str, pattern)
        local match_list = find_captures(str, pattern)
        if #match_list > 0 then
            return match_list[#match_list]
        end
    end,
    -- number
    min = function(a, b)
        if a < b then
            return a
        else
            return b
        end
    end,
    max = function(a, b)
        if a > b then
            return a
        else
            return b
        end
    end,
}

return M
