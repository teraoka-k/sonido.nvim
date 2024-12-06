local v = require("lib.vim")
local u = require('lib.util')

local M = {
    word = '',
}
local function get_options(goes_down, options)
    return 'W' .. (goes_down and '' or 'b')
end

local function search(word, goes_down, ignores_all_but_first_pattern)
    for i, pattern in ipairs(u.split(word, '/;/')) do
        if v.search('\\v' .. pattern, get_options(goes_down or i > 1)) == 0 then
            return false
        end
        if ignores_all_but_first_pattern and i == 1 then
            break
        end
    end
    return true
end

local function try_search_backwards_if_not_hit(line, column, word, goes_down)
    if line == v.line('.') and column == v.col('.') then
        -- move the cursor before the current hit and try search again
        search(word, goes_down, true)
        -- if not hitting anything, go back to the current position
        if not search(word, goes_down) then
            v.setcursorcharpos(line, column)
        end
    end
end


function M.search(
    word,
    goes_down,
    repeatable
)
    local line, column = v.get_line_column()
    word = word or M.word
    search(word, goes_down)
    try_search_backwards_if_not_hit(line, column, word, goes_down)
    if repeatable then
        M.word = word
    end
end

return M
