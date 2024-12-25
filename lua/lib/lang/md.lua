local c = require("lib.lang.common")

-- local horizontal = [[^\s[*-]$|^\s?---$|^__*$]]
local quote_or_url = [[^\> |\<https?://?.{-}\>|\<.{-}\@\..{-}\>]] .. c.next_word
local code = [[`.{-}`]]
local link_or_image = [[!?\[.{-}\]\(.{-}\)]] .. c.next_word
local list = [[^\s?([-*]|1\.) ]] .. c.skip_whitespace
local header1or2 = [[^##? .*]] .. c.skip_whitespace
local header_all = [[^#+ .*]] .. c.skip_whitespace
local font = [[([*_~]{1,3}).{-}\1($|\s)|\<ins\>.{-}\<\/ins\>/;/\w]]

return {
    angle_l = quote_or_url,
    assign = font,
    class = header1or2,
    curly_l = c.curly_l,
    fn = header_all,
    flow = list,
    paren_l = c.paren_l,
    square_l = link_or_image,
    str_l = code,
}
