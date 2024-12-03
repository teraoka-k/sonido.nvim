local u = require("lib.util")

local function starts_with(key, another)
    if key == '<' then
        if string.match(another, '<.+>') then
            return false
        end
    end
    return another:sub(1, 1) == key and another:len() > key:len()
end

return {
    -- unmap all keys starting with a specified key & modes
    escape_all_keys_starting_with = function(key, escape_to, modes, extensions)
        for _, mode in ipairs(modes) do
            vim.api.nvim_set_keymap(mode, escape_to .. key, key, { noremap = true })
        end
        vim.api.nvim_create_autocmd(
            { "BufEnter", "BufWinEnter" }, {
                pattern = u.map(extensions, function(extension) return '*.' .. extension end),
                callback = function()
                    for _, map in ipairs(vim.fn.maplist()) do
                        local _key = map.lhs
                        if starts_with(key, _key) and u.contains(map.mode, modes) then
                            vim.cmd('unmap ' .. (map.buffer == 1 and '<buffer>' or '') .. _key)
                            vim.api.nvim_set_keymap(map.mode, escape_to .. _key, map.rhs or '',
                                {
                                    callback = map.callback,
                                    desc = map.desc,
                                    expr = map.expr,
                                    noremap = map.noremap,
                                    nowait = map.nowait,
                                    script = map.script,
                                    silent = map.silent
                                }
                            )
                        end
                    end
                end
            })
    end
}
