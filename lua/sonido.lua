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

local function set_jump(jump, modes)
    if jump ~= nil and jump or jump == nil then
        local prev = 'S'
        local next = 's'
        local len = 2
        if jump ~= nil then
            prev = jump[1]
            next = jump[2]
            len = jump[3]
        end
        vim.keymap.set(modes, next, function() move.char_next(len) end)
        vim.keymap.set(modes, prev, function() move.char_prev(len) end)
    end
end

local function set_symbol(features, custom_settings, escape_to, modes)
    if custom_settings then
        default_settings = util.merge_table(default_settings, custom_settings)
    end
    for lang, settings in next, default_settings, nil do
        symbol.add(settings, features[lang] or get_default_feats(lang), escape_to, modes)
    end
end

return {
    -- { lua = { fn = {'F','f'} }, options = {modes, custom_settings, jump={'S','s', 2}},escape_to='<Leader>' }
    setup = function(features, options)
        options = options or {}
        local modes = options.modes or { 'n', 'v' }
        set_jump(options.jump, modes)
        set_symbol(features or {}, options.custom_settings, options.escape_to, modes)
    end
}
