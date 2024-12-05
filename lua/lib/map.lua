local u = require('lib.util')

local function starts_with(key, original)
    if key == '<' then
        if string.match(original, '<.->') then
            return false
        end
    end
    return string.find(original, '^' .. u.escape_pattern_symbols(key)) ~= nil and
        original:len() > key:len()
end

local function get_map_options(map)
    return {
        callback = map.callback,
        desc = map.desc,
        expr = map.expr,
        noremap = map.noremap,
        nowait = map.nowait,
        script = map.script,
        silent = map.silent
    }
end

local function delete_keymap(map)
    if map.lhs == '[[' or map.lhs == ']]' then
        vim.cmd('unmap ' .. (map.buffer and '<buffer> ' or '') .. map.lhs)
    else
        vim.keymap.del(map.mode, map.lhs, get_map_options(map))
    end
end

local function set_keymap(map, to)
    vim.api.nvim_set_keymap(map.mode, to, map.rhs or '', get_map_options(map))
end

local function foreach_keymap(keymaps, callback)
    for _, keymap in ipairs(keymaps) do
        local modes = keymap[1]
        local key = keymap[2]
        local command = keymap[3]
        callback(modes, key, command)
    end
end

local function remap_all_conflicts(modes, key, get_original_key, get_new_key)
    for _, conflict_map in ipairs(vim.fn.maplist()) do
        local original_key = get_original_key and get_original_key(conflict_map.lhs) or conflict_map.lhs
        if original_key and starts_with(key, original_key) and u.contains(conflict_map.mode, modes) then
            delete_keymap(conflict_map)
            set_keymap(conflict_map, get_new_key and get_new_key(original_key) or original_key)
        end
    end
end

local function escape_original_map(modes, key, escape_to)
    vim.keymap.set(modes, escape_to .. key, key, { noremap = true })
end
local function restore_original_map(modes, key)
    vim.keymap.del(modes, key)
    vim.keymap.set(modes, key, key, { noremap = true })
end

local function create_autocmd(events, pattern, toggle, keymaps, escape_to)
    vim.api.nvim_create_autocmd(
        events,
        {
            pattern = pattern,
            callback = function()
                foreach_keymap(keymaps, function(modes, key, command)
                    toggle(modes, key, escape_to, command)
                end)
            end
        }
    )
end
local function enable_keymaps(modes, key, escape_to, command)
    escape_original_map(modes, key, escape_to)
    vim.keymap.set(modes, key, command, { noremap = true })
    remap_all_conflicts(
        modes,
        key,
        nil,
        function(original_key) return escape_to .. original_key end
    )
end
local function disable_keymaps(modes, key, escape_to)
    restore_original_map(modes, key)
    remap_all_conflicts(
        modes,
        key,
        function(lhs) return string.match(lhs, '^' .. u.escape_pattern_symbols(escape_to) .. '(.+)') end,
        nil
    )
end

return {
    -- for specified file extension, set keymaps and unmap all keys starting with newly created keymaps
    -- the keymaps are dynamically enabled/disabled when entering/leaving buffers of the specified extension
    set_and_escape = function(keymaps, escape_to, extensions)
        escape_to = escape_to or '<Leader>'
        local file_name_pattern = u.map(extensions, function(extension) return '*.' .. extension end)
        create_autocmd({ "BufEnter", "BufWinEnter" }, file_name_pattern, enable_keymaps, keymaps, escape_to)
        create_autocmd({ "BufLeave", "BufWinLeave" }, file_name_pattern, disable_keymaps, keymaps, escape_to)
    end
}
