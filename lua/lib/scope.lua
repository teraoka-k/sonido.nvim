local s = require("lib.search")
local v = require("lib.vim")
local unmap = require("lib.unmap")

local M = {}

function M._up_or_down(is_up)
    local depth = 0
    local current_line = v.line('.')
    local line, column = s.search(
        { '{' },
        not is_up,
        false,
        {
            line = function(i, content)
                if i == current_line then return end
                if string.find(content, '{') then depth = depth + 1 end
                if string.find(content, '}') then depth = depth - 1 end
            end,
            match = function()
                return depth == 1
            end,
        }
    )
    if line and column then
        v.setcursorcharpos(line, column)
    end
end

function M._next_or_prev(is_next)
    local depth = 0
    local current_line = v.line('.')
    local line, column = s.search(
        { '{' },
        is_next,
        false,
        {
            line = function(i, content)
                if i == current_line then return end
                if string.find(content, '{') then depth = depth + 1 end
                if string.find(content, '}') then depth = depth - 1 end
                print(i, depth, content)
            end,
            match = function(line)
                return depth == 0
            end,
        }
    )
    if line and column then
        v.setcursorcharpos(line, column)
    end
end

function M.up()
    M._up_or_down(true)
end

function M.down()
    M._up_or_down(false)
end

function M.next()
    M._next_or_prev(true)
end

function M.prev()
    M._next_or_prev(false)
end

function M.setup()
    unmap.all({ 'H' }, { 'n' }, 1, { 'rs' })
    vim.keymap.set('n', 'H', M.up)
    vim.keymap.set('n', 'L', M.down)
    vim.keymap.set('n', 'J', M.next)
    vim.keymap.set('n', 'K', M.prev)
end

return M
