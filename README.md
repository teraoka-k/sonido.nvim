# Sonído

## Abstract

Sonído.nvim is **a high-speed movement technique** realized by **language-specific optimization** with **language-agnostic keymaps**

- **move to symbols with one-stroke**
  - functions, classes, interfaces, control-flows, strings, type-annotations, and ANY USER-DEFINED SYMBOL
  - repeat every movement by , ;
  - remap ANY Vim's default keybindings like `()[]`, gracefully 

## Motivation
Some movements are so generic as not to be helpful (e.g. `(` moves the cursor n-sentences backwards). Vim assigns handy labels to positions (e.g. `^` `$` `H` `L` `M` `G` etc). Let's add more language-specific labels for coding with ease. 

## Showcase
<TODO:> add a video here

- `F` or `f` move to previous or next `function`
- `T` or `t` move to previous or next type annotation
- `H` or `L` move to previous or next `class` or `struct` or `impl`
- `+` or `-` move to previous or next `if` `else` `while` `for`
- `_` or `\` move to previous or next `return` `end` 
- `=` or `_` move to previous or next assignment
- `=` or `_` move to previous or next `'string', "string"`
- `[` or `]` move to previous or next `[`
- `(` or `)` move to previous or next `(`
- `<Leader>{` or `<Leader>}` move to previous or next `{`
- `<Leader>"` or `<Leader>'` move to previous or next strings `"" ''`

**use any keymap omimal for your keyboard**

> **ANY Vim's DEFAULT KEY CAN BE REMAPPED AND STILL ACCESSIBLE!** (e.g. type `f` to move to functions and type `<Leader>f` to find a character in the line.) **Sonído adds extra value to Neovim without losing its goodeness**

## Install

### lazy.nvim
```.lua
{
    "teraoka-k/sonido.nvim",
    config = function() require("sonido").setup() end
}
```

## Config

all of the following settings are optional

I recommend to set keymaps

And if you want to add a support for a new language, read **Add A New Language** section too.

### Keymaps

```.lua
{
    config = function() require("sonido").setup({
      keymaps = {
            angle = { '<', '>' },
            assign = { '=', '_' },
            class = { 'H', 'L' },
            curly = { '<Leader>C', '<Leader>c' },
            flow = { '+', '-' },
            fn = { 'F', 'f' },
            paren = { '(', ')' },
            ret = { '|', '\\' },
            square = { '[', ']' },
            str = { '<Leader>"', "<Leader>'" },
            type = { 'T', 't' },
      },
    }) end
}
```

e.g. `fn = {'F', 'f'}` means type `F` to move to previous function, and `f` to next

#### Definitions

##### for programming languages
- angle : left angle bracket `<`
- assign: `let foo = 1` `foo = 2` `foo += 1` etc
- class : `class Foo` `Struct Foo` `impl Foo` etc
- curly : `{` 
- flow  : control flows `if` `else` `while` `for i in array` etc
- fn    : functions and closures
- paren : `(`
- ret   : `return` (`end` for lua)
- square: `[`
- str   : `"foo"` `'foo'`
- tye   : type annotations

##### for markdown 
- angle : 
> quote or <https://url>
- assign: font (**bold** *italic* <ins>underscore</ins>)
- class : # Header1 or ## Header2
- curly : `{` 
- flow  : top-level list `-` `*` `1.` 
- fn    : # ## ### ####... all headers
- paren : `(`
- ret   : Not used
- square: [link](https://) or ![image](none)
- str   : `inline-code` or code block 
- type  : Not used 

### Features

specify features to use

all features are active by default

```.lua
{
    config = function() require("sonido").setup({
      feats = {
        'angle',
        'assign',
        'class',
        'curly',
        'flow',
        'fn',
        'paren',
        'ret',
        'square',
        'str',
        'type'
      },
    }) end
}
```

### Languages

select file-extensions to activate Sonído

```.lua
{
    config = function() require("sonido").setup({
			langs = { 'lua', 'md', 'rs' },
    }) end
}
```

**If you add a new language, you must append the file-extension here**

See the **Add A New Language** section for detail 

### Modes

normal, visual, operator-pending modes are active by default 

> operator-pending: When an operator is pending (after "d", "y", "c", etc.). by [Neovim.io/doc](https://neovim.io/doc/user/map.html#mapmode-o)

```.lua
{
    config = function() require("sonido").setup({
			modes = { 'n', 'v', 'o' },
    }) end
}
```

### Escape Prefix

Vim's default keys including `[` `]` cannot be overridden easily, as many keys starting with those keys dynamically turned on/off every time buffers are opened/closed. This plugin allows users to override these keys, and the original commands of these keys are accessible by typing with a prefix (e.g.)`<EscapePrefix>[` `<EscapePrefix>]`.

```.lua
{
    config = function() require("sonido").setup({
        escape_prefix = '<Space>', 
    }) end
}
```
### Jump
a feature like minimal [easy-motion](https://github.com/easymotion/vim-easymotion)


instead of displaying labels, immediately move to the closest matched words after typing n chars, then type `,` or `;` to adjust the position

**disabled by default** as I think other people use other plugins for this feature. by the way all the features are children of this tiny feature.
```
{
    config = function() require("sonido").setup({
        jump = {
          -- S key to search backwards by 2 chars
          'S', 
          -- s key to search forwards by 2 chars
          's',
          -- 2 chars. change to any positive integer
          2, 
        },
    }) end
}
```

### Add A New Language

jsut add regex patterns as follows

```.lua
{
    config = function() require("sonido").setup({

      -- a file extension
        langs = { 'js' },

      -- add keymaps for user-defined regex
        keymaps = { 
          user_defined_custom_symbol = {
            '<Leader>P', '<Leader>p'
          },          
        },
      
      -- define symbols for each language
        symbols= {

      -- a file extension
          js = {
            angle     = { '<' },
            assign  = { '= (.+)'},
            class   = { 'class (.-)'},
            curly   = { '{' },
            flow    = {
              "for %(.-in.-%)","for %(.-of.-%) ",
              "while ", "if ", "else "
            },

            -- `.-` is like `.*` but non-greedy
            fn      = { "function (.+)", "(.-) => " },

            paren   = { '%(' },
            square  = { '%[' },
            str     = { "'.-'", '".-"', '`.-`' },

            user_defined_custom_symbol = {'private '},
          }

      -- a file extension
          cpp = {...}

        }
      })
    end
}
```

Folllow the two rules below

#### 1 Search by Regex, Move to Capture
use `^` `$` `!` `.` `?` `+` `-` `*` `[` `]` `(` `)` `%` as lua's regular expressions

##### Exmaple
suppose there's a line `let foo = "hello Sonido";`

- use `'^let .- = .+$'` to move to `l`
- use `'^let (.-) = .+$'` to move to `foo`

> here `.-` is like `.*` but non-greedy

#### 2 Escape
escape `^` `$` `!` `.` `?` `+` `-` `*` `[` `]` `(` `)` `%` by `%`

##### Example
use `'%('` to move to `(`


#### Side Note

it's better to put the symbols into a separate file as they grow up easily as time goes on

##### js.lua
```lua
return {
  angle = {},
  assign = {},
  ...
}
```

and import it to init.lua so that it's easy to adjust settings reagardless of number of languages

##### init.lua
```lua
{
    config = function() require("sonido").setup({
        langs = { 'js' },
        keymaps = { 
          user_defined_custom_symbol = {
            '<Leader>P', '<Leader>p'
          },          
        },
        symbols = {
          js = require("<path-to->/js.lua"),
          cpp = require("<path-to->/cpp.lua"),
        }
```

**here any help is valuable. It only starts with 3 languages rs, lua, md. I appriciate if you try anoother language and so generous to open a PR to this repostiory** 

<TODO:> write how to open a PR for this repo

## Limitation
- Non-English letters are not supported as lua's `string.find` function does not work for other languages
  - hence, if a line include words like `Sonído` and `響転 (ソニード)` the cursor cannot be moved correctly
