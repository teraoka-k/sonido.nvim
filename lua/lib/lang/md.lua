-- (.-) is like (.*) but non-greedy

local code = { '[ *]`(.-)`$?', '```' }
local horizontal = { '^%s[*-]$', '^%s?%-%-%-$', '^__+$' }
local image = { '%!%[%.*]%(.-%)' }
local link = { '%[.*%]%(.-%)' }
local list = { '^%s?[-*] ', '^%s?1%. ' }
local quote = { '> ' }
local url = { '<https?://.+%..+>', '<.+%@%.+>' }

return {
    { 'md' },
    {
        code = code,
        font = { ' [*_~][*_~][*_~]?(.-)[*_~][*_~][*_~]?', '<ins>(.+)<ins>' },
        h = { '^##? (.+)' },
        h_all = { '^#+ (.+)' },
        horizontal = horizontal,
        image = image,
        link = link,
        list = list,
        quote = quote,
        url = url,
    }
}
