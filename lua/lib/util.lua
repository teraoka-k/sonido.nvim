local function max(a, b)
    if a > b then
        return a
    else
        return b
    end
end
local function escape_pattern_symbols(str)
    local escape = str:gsub('%%', '%%%%')
    for _, char in ipairs({ '(', ')', '[', ']', '.', '*', '?', '+', '-', '^', '$' }) do
        escape = escape:gsub('%' .. char, '%%' .. char)
    end
    return escape
end
local function find_capture(str, pattern)
    local captures = { string.find(str, pattern) }
    local start_at
    local end_at
    local capture
    for i, _capture in ipairs(captures) do
        if i == 1 then
            start_at = _capture
        elseif i == 2 then
            end_at = _capture
        else
            capture = _capture
        end
    end
    if not capture then
        return start_at, end_at, capture
    end
    if start_at then
        return (start_at + string.find(str:sub(start_at), escape_pattern_symbols(capture)) - 1), end_at, capture
    end
end
local function find_captures(str, pattern)
    local match_list = {}
    local start_at = 1
    while true do
        local _start_at, end_at, capture = find_capture(str, pattern)
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
        for _, _char in ipairs(chars) do
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
    merge_arrays = function(arrays)
        local arr = {}
        for _, array in ipairs(arrays) do
            for _, v in ipairs(array) do
                table.insert(arr, v)
            end
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
    merge_table = function(t1, t2)
        local new_t = {}
        for k, v in next, t1, nil do
            new_t[k] = v
        end
        for k, v in next, t2, nil do
            new_t[k] = v
        end
        return new_t
    end,
    -- string
    split = function(str, delimiter)
        local result               = {}
        local from                 = 1
        local delim_from, delim_to = string.find(str, delimiter, from)
        while delim_from do
            table.insert(result, string.sub(str, from, delim_from - 1))
            from                 = delim_to + 1
            delim_from, delim_to = string.find(str, delimiter, from)
        end
        table.insert(result, string.sub(str, from))
        return result
    end,
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
    escape_pattern_symbols = escape_pattern_symbols,
    -- number
    min = function(a, b)
        if a < b then
            return a
        else
            return b
        end
    end,
    max = max,
    max_of = function(array)
        local _max = 0
        for _, n in ipairs(array) do
            _max = max(n, _max)
        end
        return _max
    end,
}

return M
