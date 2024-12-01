local M = {}


local function contains(char, chars)
    for i, _char in ipairs(chars) do
        if _char == char then
            return true
        end
    end
    return false
end

-- unmap all keys starting with specified keys & modes, whose length is larger than `len`
function M.all(first_key_list, modes, len)
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function()
            for _, map in ipairs(vim.fn.maplist()) do
                local key = map.lhs
                if contains(key:sub(1, 1), first_key_list) and contains(map.mode, modes) and string.len(key) > len then
                    vim.cmd('unmap ' .. (map.buffer == 1 and '<buffer>' or '') .. key)
                end
            end
        end
    })
end

return M
