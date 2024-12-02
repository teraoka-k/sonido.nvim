local u = require("lib.util")
local v = require("lib.vim")
local m = require("lib.move")
local unmap = require("lib.unmap")

local function new(key_prev, key_next, definitions, repeatable)
    local function next_or_prev(move)
        local symbols = u.map(definitions[v.extension()] or definitions['_'], function(symbol)
            local sub, _ = symbol:gsub("[(]", "%%(")
            sub, _ = sub:gsub("[)]", "%%)")
            return sub
        end)
        if symbols then
            move(symbols, false, true, repeatable)
        end
    end
    local function next()
        next_or_prev(m.to_char)
    end
    local function prev()
        next_or_prev(m.to_char_reverse)
    end
    local extensions = u.keys(definitions)
    unmap.all({ key_prev, key_next }, { 'n' }, u.max(key_next:len(), key_next:len()),
        u.contains('_', extensions) and { '*' } or extensions)
    vim.keymap.set('n', key_prev, prev)
    vim.keymap.set('n', key_next, next)
    return { next, prev }
end

local js = { 'function ', '=> ', 'class ', 'enum ' }
local ts = u.merge(js, { 'interface ', 'type ' })
local keyword = {
    rs = { "fn ", "struct ", "impl ", "trait " },
    lua = { "function(", "function " },
    md = { "#+" },
    js,
    jsx = js,
    ts,
    tsx = ts,
}
local assign = {
    _ = { ' = ', '+=', '-=', '/=', '*=', '|=', '&=', '&&=', '||=', ' < ', ' > ', ' <= ', ' >= ' }
}
local list = {
    lua = { '{' },
    _ = { '[' }
}
local paren = {
    _ = { '(' }
}
local str = {
    _ = { "'.*'", '".*"', '`.*`' }
}

local function new_assign()
    new('=', '=', assign, true)
end
local function new_list()
    new('{', '}', list, false)
end
local function new_keyword()
    new('[', ']', keyword, false)
end
local function new_paren()
    new('(', ')', paren, false)
end
local function new_str()
    new('"', "'", str, false)
end

local function config(definition, option, default)
    if option then
        new(option.prev, option.next, definition, option.repeatable)
    else
        default()
    end
end


return {
    setup = function()
        new_assign()
        new_list()
        new_keyword()
        new_paren()
        new_str()
    end,
    -- config({keyword={prev='[', next=']', repeatable=false}, assign={...}, list={...}, paren={...}, str={...} })
    config = function(options)
        config(assign, options.assign, new_assign)
        config(keyword, options.keyword, new_keyword)
        config(list, options.list, new_list)
        config(paren, options.paren, new_paren)
        config(str, options.str, new_str)
    end,
    new,
}
