local move = require("lib.move")
local util = require('lib.util')
local symbol = require("lib.symbol")
local md = require("lib.lang.md")
local rs = require("lib.lang.rs")
local js = require("lib.lang.js")
local lua = require("lib.lang.lua")

local function set_jump(jump, modes)
    if jump ~= nil and jump then
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

local function set_langs(options)
    for _, lang in ipairs(options.langs) do
        local symbols = options.symbols[lang]
        if symbols then
            symbol.add(lang, symbols, options.keymaps, options.escape_prefix, options.modes, options.is_repeatable)
        end
    end
end

return {
    --{
    --    modes = { 'n', 'v', 'o' },
    --    langs = { 'lua', 'md', 'rs' },
    --    feats = { 'assign', 'class', 'curly', 'flow', 'fn', 'paren', 'square', 'str', 'angle', 'type' },
    --    keymaps = {
    --        angle = { '<', '>' },
    --        assign = { '=', '_' },
    --        class = { 'H', 'L' },
    --        curly = { '{', '}' },
    --        flow = { '+', '-' },
    --        fn = { 'F', 'f' },
    --        paren = { '(', ')' },
    --        square = { '[', ']' },
    --        str = { '"', "'" },
    --        type = { 'T', 't' },
    --    },
    --    symbols = { lua = { assign = { 'local (.-) = ' } } },
    --    escape_prefix = '<Leader>',
    --    is_repeatable = true,
    --    jump = { 'S', 's', 2 },
    --}
    setup = function(options)
        if not options.keymaps then
            error("set keymaps to use sonido.nvim")
        end
        options.modes = options.modes or { 'n', 'v' }
        options.langs = options.langs or { 'js', 'jsx', 'lua', 'md', 'rs', 'ts', 'tsx' }
        options.is_repeatable = options.is_repeatable == nil and true or options.is_repeatable
        options.escape_prefix = options.escape_prefix or '<Leader>'
        -- filter out keymaps by features
        if options.feats then
            local keymaps = {}
            for feat, keymap in next, options.keymaps do
                if util.contains(feat, options.feats) then
                    keymaps[feat] = keymap
                end
            end
            options.keymaps = keymaps
        end
        vim.api.nvim_create_user_command('Sonido', function()
            print(vim.inspect(options.keymaps))
        end, {})

        -- add or override symbols
        local symbols = { js = js, jsx = js, lua = lua, md = md, rs = rs, ts = js, tsx = js }
        if options.symbols then
            for lang, new_symbols in next, options.symbols do
                if symbols[lang] then
                    for feat, new_symbol in next, new_symbols do
                        symbols[lang][feat] = new_symbol
                    end
                else
                    symbols[lang] = new_symbols
                end
            end
            options.symbols = symbols
        else
            options.symbols = symbols
        end

        set_jump(options.jump, options.modes)
        set_langs(options)
    end
}
