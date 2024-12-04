local move = require("lib.move")
local util = require('lib.util')
local symbol = require("lib.symbol")
local md = require("lib.lang.md")
local rs = require("lib.lang.rs")
local lua = require("lib.lang.lua")

local default_settings = { lua = lua, md = md, rs = rs }

local function get_default_feats(lang_name)
    if lang_name == 'md' then
        return {
            code = { '~', '`' },
            font = { '"', "'" },
            h = { 'H', 'L' },
            h_all = { 'F', 'f' },
            link = { '[', ']' },
            list = { '+', '-' },
            quote = { '<', '>' },
        }
    end
    return {
        assign = { '=', '_' },
        class = { 'H', 'L' },
        curly = { '{', '}' },
        flow = { '+', '-' },
        fn = { 'F', 'f' },
        paren = { '(', ')' },
        square = { '[', ']' },
        str = { '"', "'" },
        tag = { '<', '>' },
        type = { 'T', 't' },
    }
end

return {
    -- { lua = { fn = {'F','f'} } }
    setup = function(features, custom_settings)
        -- move to matched chars
        vim.keymap.set('n', 's', function() move.char_next(2) end)
        vim.keymap.set('n', 'S', function() move.char_prev(2) end)

        if custom_settings then
            default_settings = util.merge_table(default_settings, custom_settings)
        end

        -- move to symbols
        features = features or {}
        for lang, settings in next, default_settings, nil do
            -- print(vim.inspect(lang))
            -- print(vim.inspect(settings))
            -- print(vim.inspect(features[lang]))
            -- print(vim.inspect(get_default_feats(lang)))
            symbol.add(settings, features[lang] or get_default_feats(lang))
        end
    end
}
