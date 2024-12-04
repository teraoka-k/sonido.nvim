local move = require("lib.move")
local map = require("lib.map")

local function bind_keymaps(extensions, key_prev, key_next, symbols, escape_to, modes)
    local function next_or_prev(to_char)
        to_char(symbols, true, true)
    end
    local function next()
        next_or_prev(move.to_char)
    end
    local function prev()
        next_or_prev(move.to_char_reverse)
    end
    map.set_and_escape(
        { { modes, key_prev, prev }, { modes, key_next, next } },
        escape_to,
        extensions
    )
    return { next, prev }
end

return {
    add = function(lang, features, escape_to, modes)
        local extensions = lang[1]
        local definitions = lang[2]
        for name, symbols in next, definitions, nil do
            local keys = features[name]
            if keys then
                local key_prev = keys[1]
                local key_next = keys[2]
                bind_keymaps(extensions, key_prev, key_next, symbols, escape_to, modes)
            end
        end
        map.set_and_escape({ { modes, ',', move.prev }, { modes, ';', move.next } }, escape_to, extensions)
    end
}
