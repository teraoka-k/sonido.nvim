local c = require('lib.lang.common')

return {
    angle_l = c.angle_l,
    angle_r = c.angle_r,
    assign = c.assign,
    curly_l = c.curly_l,
    curly_r = c.curly_r,
    paren_l = c.paren_l,
    paren_r = c.paren_r,
    square_l = c.square_l,
    square_r = c.square_r,
    str_l = c.str_l,
    str_r = c.str_r,

    class = [[^(local .* = |return \{)]] .. c.skip_whitespace,
    fn = 'function[( ]',
    flow = '(for .* in|while|loop|if|else) |(else|do|repeat|break|goto .*)$' .. [[/;/( |$)/;/\S]],
    ret = [[(return.*|end)$]],
}
