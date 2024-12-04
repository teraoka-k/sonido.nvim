local u = require('lib.util')
local default_escape_to = '<Leader>'

return {
    -- for specified file extension, set keymaps and unmap all keys starting with newly created keymaps
    -- the keymaps are dynamically enabled/disabled when entering/leaving buffers of the specified extension
    set_and_escape = function(keymaps, escape_to, extensions)
        escape_to = escape_to or default_escape_to

        local function remap(map, to)
            vim.api.nvim_set_keymap(map.mode, to, map.rhs or '',
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

        local function starts_with(key, original)
            if key == '<' then
                if string.match(original, '<.+>') then
                    return false
                end
            end
            return original:sub(1, 1) == key and original:len() > key:len()
        end

        local function enable(modes, key, callback)
            vim.keymap.set(modes, key, callback, { noremap = true })
            vim.keymap.set(modes, escape_to .. key, key, { noremap = true })
            for _, map in ipairs(vim.fn.maplist()) do
                local original = map.lhs
                if starts_with(key, original) and u.contains(map.mode, modes) then
                    vim.cmd('unmap ' .. (map.buffer == 1 and '<buffer>' or '') .. original)
                    remap(map, escape_to .. key)
                end
            end
        end

        local function disable(modes, key)
            vim.keymap.del(modes, key)
            vim.keymap.set(modes, key, key, { noremap = true })
            for _, map in ipairs(vim.fn.maplist()) do
                local _key = map.lhs
                local original_key = string.match(_key, u.escape_pattern_symbols(escape_to) .. '(.+)')
                if original_key and original_key.sub(1, 1) == key and u.contains(map.mode, modes) then
                    vim.cmd('unmap ' .. (map.buffer == 1 and '<buffer>' or '') .. _key)
                    remap(map, original_key)
                end
            end
        end

        for _, keymap in ipairs(keymaps) do
            local modes = keymap[1]
            local key = keymap[2]
            local callback = keymap[3]
            local pattern = u.map(extensions, function(extension) return '*.' .. extension end)
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    pattern = pattern,
                    callback = function() enable(modes, key, callback) end
                }
            )
            vim.api.nvim_create_autocmd(
                { "BufLeave", "BufWinLeave" },
                {
                    pattern = pattern,
                    callback = function() disable(modes, key) end
                }
            )
        end
    end
}
