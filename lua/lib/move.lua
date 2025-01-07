local v = require("lib.vim")
local s = require("lib.search")

local M = {
    godown = true
}

local function to_char(len, move)
    local chars = v.get_chars(len)
    if chars ~= '' then
        move(chars, true, true, 0, true)
    end
end

function M.char_next(len)
    to_char(len, M.to_char)
end

function M.char_prev(len)
    to_char(len, M.to_char_reverse)
end

function M.next()
    (M.godown and M.to_char or M.to_char_reverse)()
end

function M.prev()
    (M.godown and M.to_char_reverse or M.to_char)()
end

function M._to_char(
    word,
    godown,
    repeatable,
    updates_direction
)
    s.search(word, godown, repeatable)
    if updates_direction then
        M.godown = godown
    end
end

function M.to_char(word, updates_direction, repeatable)
    M._to_char(
        word,
        true,
        repeatable,
        updates_direction
    )
end

function M.to_char_reverse(word, updates_direction, repeatable)
    M._to_char(
        word,
        false,
        repeatable,
        updates_direction
    )
end

return M
