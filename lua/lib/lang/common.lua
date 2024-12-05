return {
    angle = { '<' },
    assign = { ' = (.+)', ' %+= (.+)', ' %-= (.+)', ' /= (.+)', ' %*= (.+)', ' |= (.+)', ' &= (.+)', ' &&= (.+)', '||= (.+)', '.+ < (.+)', '.+ > (.+)', '.+ <= (.+)', '.+ >= (.+)' },
    class = { 'class ' },
    curly = { '{' },
    flow = { "for .* in ", "while ", "loop ", "if ", "else ", "else$" },
    paren = { '%(' },
    ret = { 'return$', 'return (.-)$' },
    square = { '%[' },
    -- - is like * but non-greedy
    str = { "'.-'", '".-"', '`.-`' },
}
