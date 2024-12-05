-- Obey 3 rules to add a support for a new language

-- [RULE 1]
-- use ^ $ ! . ? + - * [] ( ) % as regular expressions
--   Exmaple
--     suppose there's a line `let foo = "hello Sonido";`
--     use '^let (.+) = .+$' to move to `foo`

-- [RULE 2]
-- escape ^ $ ! . ? + - * [ ] ( ) % by %
--   Example
--     use '%(' to move to left-paren

-- [RULE 3]
-- use following keywords
--   assign: assign values to variables, or compare variables
--   class : top-level structures in a file, (class, struct, interface, etc)
--   curly : {}
--   flow  : control flows, like loops and if-else statements
--   fn =  : "fn ", "|.*| {" },
--   paren : ()
--   square: []
--   str   : '' "" ``
--   angle   : <>
--   type  : type annotations (for static lanuages). as type definitions are top-level structure, define them in the class sections
--   or_any_keyword_that_you_find_more_helpful: ...

return {
    assign = { '= (.+)', '%+= (.+)', '%-= (.+)', '/= (.+)', '%*= (.+)', '|= (.+)', '&= (.+)', '&&= (.+)', '||= (.+)', ' < (.+)', ' > (.+)', ' <= (.+)', ' >= (.+)' },
    class = { 'class ' },
    curly = { '{' },
    flow = { "for .* in ", "while ", "loop ", "if ", "else ", "else$" },
    paren = { '%(' },
    square = { '%[' },
    -- `.-` is like `.*` but non-greedy
    str = { "'.-'", '".-"', '`.-`' },
    angle = { '<' },
}
