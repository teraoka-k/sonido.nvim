local move = require("lib.move")
local map = require("lib.map")

local function bind_keymaps(extensions, key_prev, key_next, symbol, escape_prefix, modes)
    local function next_or_prev(to_char)
        to_char(symbol, true, true)
    end
    local function next()
        next_or_prev(move.to_char)
    end
    local function prev()
        next_or_prev(move.to_char_reverse)
    end
    map.set_and_escape(
        { { modes, key_prev, prev }, { modes, key_next, next } },
        escape_prefix,
        extensions
    )
    return { next, prev }
end

return {
    add = function(lang, symbols, keymaps, escape_prefix, modes, is_repeatable)
        for feat, symbol in next, symbols, nil do
            local keymap = keymaps[feat]
            if keymap then
                bind_keymaps({ lang }, keymap[1], keymap[2], symbol, escape_prefix, modes)
            end
        end
        if is_repeatable then
            map.set_and_escape({ { modes, ',', move.prev }, { modes, ';', move.next } }, escape_prefix, { lang })
        end
    end
}
