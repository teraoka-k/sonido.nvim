local u = require("lib.util")
local v = require("lib.vim")
local m = require("lib.move")
local unmap = require("lib.unmap")

local function new(key_prev, key_next, definitions, repeatable, goback)
    local function next_or_prev(move)
        local symbols = definitions[v.extension()] or definitions._
        if symbols then
            move(symbols, true, repeatable, goback)
        end
    end
    local function next()
        next_or_prev(m.to_char)
    end
    local function prev()
        next_or_prev(m.to_char_reverse)
    end
    local extensions = u.keys(definitions)
    for _, key in ipairs({ key_prev, key_next }) do
        unmap.escape_all_keys_starting_with(
            key,
            '<Leader>',
            { 'n' },
            u.contains('_', extensions) and { '*' } or extensions
        )
    end
    vim.keymap.set('n', key_prev, prev, { noremap = true })
    vim.keymap.set('n', key_next, next, { noremap = true })
    return { next, prev }
end

local assign = {
    _ = { '= (.+)', '%+= (.+)', '%-= (.+)', '/= (.+)', '%*= (.+)', '|= (.+)', '&= (.+)', '&&= (.+)', '||= (.+)', ' < (.+)', ' > (.+)', ' <= (.+)', ' >= (.+)' }
}
local js_class = { 'class ', 'enum ' }
local ts_class = u.merge(js_class, { 'interface ', 'type ' })
local class = {
    rs = { "struct (.+)", "impl (.+)", "trait (.+)" },
    js = js_class,
    jsx = js_class,
    ts = ts_class,
    tsx = ts_class,
    lua = { 'local .* = {' },
    _ = { 'class ' }
}
local curly = {
    _ = { '{' }
}
local flow = {
    rs = { "for .* in ", "while ", "loop ", "if ", "else " },
    lua = { "for .* in ", "repeat ", "if ", "else" },
    _ = { "for .* [io][nf] ", "while ", "loop ", "if ", "else " },
}
local js = { 'function ', '%(?.*%)? => ' }
local fn = {
    rs = { "fn ", "|.*| {" },
    lua = { "function%(", "function " },
    js,
    jsx = js,
    ts = js,
    tsx = js,
    py = { "def " }
}
local paren = {
    _ = { '%(' }
}
local str = {
    _ = { "'.*'", '".*"', '`.*`' }
}
local square = {
    _ = { '%[' }
}
local tag = {
    _ = { '<' }
}
local type = {
    rs = { ': ([a-zA-Z0-9_<>&*]+)[,%) ]', '-> ([a-zA-Z0-9_<>&*]+)' }
}

local function new_assign()
    new('=', '_', assign)
end
local function new_class()
    new('H', 'L', class)
end
local function new_flow()
    new('+', '-', flow)
end
local function new_curly()
    new('{', '}', curly)
end
local function new_fn()
    new('F', 'f', fn)
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
local function new_type()
    new('T', "t", type)
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
        new_type()
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
        config(tag, options.tag, new_tag)
        config(type, options.type, new_type)
    end,
    new,
}
