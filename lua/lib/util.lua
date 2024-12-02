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
    -- number
    max = function(a, b)
        if a > b then
            return a
        else
            return b
        end
    end,
}

return M
