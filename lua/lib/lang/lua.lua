local c = require('lib.lang.common')

return {
    angle = c.angle,
    assign = c.assign,
    curly = c.curly,
    paren = c.paren,
    square = c.square,
    str = c.str,

    class = [[^(local .* = |return \{)]] .. c.skip_whitespace,
    fn = 'function[( ]',
    flow = '(for .* in|while|loop|if|else) |(else|do|repeat|break|goto .*)$' .. [[/;/( |$)/;/\S]],
    ret = [[(return.*|end)$]],
}
