return {
    hi = function(msg)
        print("hi " .. msg)
    end,
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
        for i, element in ipairs(array) do
            table.insert(new_map, fn(element))
        end
        return new_map
    end,
    -- string
    endswith = function(str, ending)
        return str:sub(- #ending) == ending
    end,
}
