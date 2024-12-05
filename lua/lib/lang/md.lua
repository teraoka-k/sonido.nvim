local c = require("lib.lang.common")
-- local horizontal = { '^%s[*-]$', '^%s?%-%-%-$', '^__+$' }
local quote_or_url = { '^> ', '<https?://.+%..+>', '<.+%@%.+>' }
local code = { '[ *]`(.-)`$?', '```' }
local link_or_image = { '%!?%[.*%]%(.-%)' }
local list = { '^%s?[-*] ', '^%s?1%. ' }
local header1or2 = { '^##? (.+)' }
local header_all = { '^#+ (.+)' }
local font = { ' [*_~][*_~][*_~]?(.-)[*_~][*_~][*_~]?', '<ins>(.+)<ins>' }

return {
    angle = quote_or_url,
    assign = font,
    class = header1or2,
    curly = c.curly,
    fn = header_all,
    flow = list,
    paren = c.paren,
    square = link_or_image,
    str = code,
}
