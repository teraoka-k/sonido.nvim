local u = require("lib.util")
local v = require("lib.vim")
local m = require("lib.move")
local unmap = require("lib.unmap")

local function new(key_prev, key_next, definitions, repeatable)
    local function next_or_prev(move)
        local symbols = u.map(definitions[v.extension()] or definitions['_'], function(symbol)
            local sub, _ = symbol:gsub("[(]", "%%(")
            sub, _ = sub:gsub("[)]", "%%)")
            sub, _ = sub:gsub("%[", "%%[")
            sub, _ = sub:gsub("%]", "%%]")
            return sub
        end)
        if symbols then
            move(symbols, true, repeatable)
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

local assign = {
    _ = { ' = ', '+=', '-=', '/=', '*=', '|=', '&=', '&&=', '||=', ' < ', ' > ', ' <= ', ' >= ' }
}
local js_class = { 'class ', 'enum ' }
local ts_class = u.merge(js_class, { 'interface ', 'type ' })
local class = {
    rs = { "struct ", "impl ", "trait " },
    js = js_class,
    jsx = js_class,
    ts = ts_class,
    tsx = ts_class
}
local curly = {
    _ = { '{' }
}
local flow = {
    rs = { "for .* in ", "while ", "loop ", "if ", "else " },
}
local js = { 'function ', '(?.*)? => ' }
local fn = {
    rs = { "fn ", "|.*| {" },
    lua = { "function(", "function " },
    js,
    jsx = js,
    ts = js,
    tsx = js,
    py = { "def " }
}
local paren = {
    _ = { '(' }
}
local str = {
    _ = { "'.*'", '".*"', '`.*`' }
}
local square = {
    _ = { '[' }
}
local tag = {
    _ = { '<' }
}

local function new_assign()
    new('=', '=', assign, true)
end
local function new_class()
    new('H', 'L', class)
end
local function new_flow()
    new('_', '_', flow, true)
end
local function new_curly()
    new('{', '}', curly)
end
local function new_fn()
    new('K', 'J', fn)
end
local function new_paren()
    new('(', ')', paren)
end
local function new_str()
    new('"', "'", str)
end
local function new_square()
    new('[', ']', square)
end
local function new_tag()
    new('<', '>', tag)
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
        new_class()
        new_curly()
        new_fn()
        new_flow()
        new_paren()
        new_square()
        new_str()
        new_tag()
    end,
    -- config({class={prev='[', next=']', repeatable=false}, assign={...}, list={...}, paren={...}, str={...} })
    config = function(options)
        config(assign, options.assign, new_assign)
        config(class, options.class, new_class)
        config(fn, options.fn, new_fn)
        config(flow, options.flow, new_flow)
        config(square, options.list, new_square)
        config(paren, options.paren, new_paren)
        config(str, options.str, new_str)
    end,
    new,
}
