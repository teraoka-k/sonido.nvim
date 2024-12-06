local c = require('lib.lang.common')

return {
    angle = c.angle,
    assign = c.assign,
    curly = c.curly,
    paren = c.paren,
    square = c.square,
    str = c.str,

    class = [[(struct|impl|trait|mod) .*\{]] .. c.skip_whitespace,
    fn = 'fn ' .. c.skip_whitespace,
    flow = [[(for .* in|while|loop|if|else if|else|match) |(break|continue);]] .. c.skip_whitespace,
    pub = 'pub ' .. c.skip_whitespace,
    pri = [[^\s*fn /;/fn]] .. c.skip_whitespace,
    ret = [[return]] .. c.skip_whitespace,
    type = [[: (\w|_|\&|\*|\<|\>| )+[,)=]|-\> \S]] .. c.skip_whitespace,
}
