local next_word = [[/;/\S]]

return {
    angle = [[\<]] .. next_word,
    assign = [[\S+\s?[+-\*&|<>=]?(&&|||)?\=\s?.*$]] .. '/;/\\=' .. next_word,
    class = 'class ' .. next_word,
    curly = [[\{]] .. next_word,
    flow = [[(for .* in|while|loop|if|else) ]],
    paren = [[\(]] .. next_word,
    pub = [[public ]],
    pri = [[private ]],
    ret = [[return.*$]],
    square = '\\[' .. next_word,
    str = [[(['"`]).{-}\1]] .. next_word,
    skip_whitespace = [[/;/ /;/\S]],
    next_word = next_word
}
