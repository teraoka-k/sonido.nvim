local next_word = [[/;/\S]]

return {
    angle_l = [[\<]] .. next_word,
    angle_r = [[(\=)@<!\>]],
    assign = [[\S+\s?[+-\*&|<>=]?(&&|||)?\=(\>)@!\s?.*$]] .. '/;/\\=' .. next_word,
    class = 'class ' .. next_word,
    curly_l = [[\{]] .. next_word,
    curly_r = [[\}]],
    flow = [[(for .* in|while|loop|if|else) ]],
    paren_l = [[\(]] .. next_word,
    paren_r = [[\)]],
    pub = [[public ]],
    pri = [[private ]],
    ret = [[return.*$]],
    square_l = '\\[' .. next_word,
    square_r = '\\]',
    str_l = [[(['"`]).{-}\1]] .. next_word,
    str_r = [[(['"`]).{-}\1]] .. next_word .. [[(['"`])]],
    skip_whitespace = [[/;/ /;/\S]],
    next_word = next_word
}
