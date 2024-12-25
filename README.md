# Sonído

## Abstract

Define regex once, use it anywhere to navigate through code

## Motivation
When writing a program, you always repeat the same workflow

1. skim through top-level structures like class
2. go into the class to skim through functions
3. go into the function to skim through control flows like if, else, while, or for
4. go into the control flow to edit
  - function calls
  - variable assignments and comparisons
  - literals like string, index, key
  - type annotations
5. go back to 1, 2, or 3

So, shortcuts to navigate to 1,2,3, and 4 are handy

If you haven't setup such keymaps by yourself yet, Sonído is here for you to do that


## Showcase

https://github.com/user-attachments/assets/329e47dd-08c5-49b6-8c44-c40bc6647048

**they are just an example. define regex as your liking**

> **Vim's DEFAULT COMMANDS ARE STILL ACCESSIBLE!** (e.g. type `f` to move to functions and type `<Leader>f` to find a character in the line)

## Install

### lazy.nvim
```.lua
{
    "teraoka-k/sonido.nvim",
    config = function() require("sonido").setup({
      langs = {
        'lua','md','rs',
        -- read `Add A New Language` section for other languages and define regex
      },
      keymaps = {
            angle_l = { '<', '>' },
            assign_l = { '=', '_' },
            class = { 'H', 'L' },
            curly_l = { '<Leader>C', '<Leader>c' },
            flow = { '+', '-' },
            fn = { 'F', 'f' },
            paren_l = { '(', ')' },
            pri = {'<Leader>Fp','<Leader>fp'},
            pub = {'<Leader>FP','<Leader>fP'},
            ret = { '|', '\\' },
            square_l = { '[', ']' },
            str_l = { '<Leader>"', "<Leader>'" },
            type = { 'T', 't' },
      },
    }) end
}
```

e.g. `fn = {'F', 'f'}` means type `F` to move to previous function, and `f` to next

#### Definitions

default features' definitions

##### for programming languages
- angle_l : left angle bracket `<`
- angle_r : left angle bracket `>`
- assign: `let foo = 1` `foo = 2` `foo += 1` etc
- class : `class Foo` `Struct Foo` `impl Foo` etc
- curly_l : `{` 
- curly_r : `}` 
- flow  : control flows `if` `else` `while` `for i in array` etc
- fn    : functions and closures
- paren_l : `(`
- paren_r : `)`
- pri   : private
- pub   : public
- ret   : `return` (`end` for lua)
- square_l: `[`
- square_r: `]`
- str_l   : f for `"foo"` `'foo'`
- str_r   : o for `"foo"` `'foo'`
- type   : type annotations

##### for markdown 
- angle_l : 
> quote or <https://url>
- assign  : font (**bold** *italic* <ins>underscore</ins>)
- class   : # Header1 or ## Header2
- curly_l : `{` 
- flow    : top-level list `-` `*` `1.` 
- fn      : # ## ### ####... all headers
- paren_l : `(`
- square_l: [link](https://) or ![image](none)
- str_l   : `inline-code` or code block 

## Config

all of the settings below are optional

if you want to add a support for a new language, read **Add A New Language** section too.

### Features

specify features to use

all features are active by default

```.lua
{
    config = function() require("sonido").setup({
      feats = {
        'angle_l',
        'angle_r',
        'assign',
        'class',
        'curly_l',
        'curly_r',
        'flow',
        'fn',
        'paren_l',
        'paren_r',
        'pri',
        'pub',
        'ret',
        'square_l',
        'square_r',
        'str_l',
        'str_r',
        'type',
        -- and any custom features
        -- 'custom_feature_1'
      },
    }) end
}
```

### Languages

select file-extensions to activate Sonído

```.lua
{
    config = function() require("sonido").setup({
			langs = {
                'lua', 'md', 'rs',
                -- and any user_defined file types
                -- 'js',
            },
    }) end
}
```

**To use languages other than 'lua', 'md', 'rs', you must define regex**

See the **Add A New Language** section for detail 

### Repeat

all the movement is repeatalbe by default

```
{
    config = function() require("sonido").setup({
      is_repeatable = true
    }) end
}
```

### Modes

normal and visual modes are active by default 

```.lua
{
    config = function() require("sonido").setup({
			modes = { 'n', 'v', 'i', 'o' },
    }) end
}
```

### Escape Prefix

Vim's default keys including `[` `]` cannot be overridden easily, as many keys starting with those keys dynamically turned on/off every time buffers are opened/closed. This plugin allows users to override these keys, and the original commands of these keys are accessible by typing with a prefix (e.g.)`<EscapePrefix>[` `<EscapePrefix>]`.

default is `<Leader>`

```.lua
{
    config = function() require("sonido").setup({
        escape_prefix = '<Leader>', 
    }) end
}
```
### Jump
a feature like minimal [easy-motion](https://github.com/easymotion/vim-easymotion)


instead of displaying labels, immediately move to the closest matched words after typing n chars, then type `,` or `;` to adjust the position

**disabled by default**
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

add regular expressions as follows

all the patterns are `very magic`. any pattern that works as `/\v pattern` should work for Sonído too.
run `:h pattern` and search `very magic` for detail 

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
            angle_l = [[\<]],
            assign = [[\S+\s?[+-\*&|<>=]?(&&|||)?\=\s?\S]],

            -- class = 'class ', -- move to `c`
            class = 'class /;/ /;/\S', -- move to `F` for `class Foo`

            curly_l = [[\{]],
            flow = [[(for .* (in|of)|while|if|else) ]],

            -- fn= "function .{-}|(.{-}) => ", -- move to `f`
            fn= "function .{-}|(.{-}) => /;/ /;/\S", -- move to `b` for `function bar(...)`

            paren_l = [[\(]],
            pri = [[private /;/ /;/\S]],
            pub = [[public /;/ /;/\S]],
            ret = [[return.*$]],
            square_l = '\\[',
            str_l = [[(['"`]).{-}\1]]

            user_defined_custom_symbol = 'private ',
          }

      -- a file extension
          cpp = {...}

        }
      })
    end
}
```

as in Vim's default search, use `foo/;/bar` to move to `bar` preceeded by `foo`

#### File Mangement

it's better to put the symbols to separate files as they grow up easily as time goes on

##### ~/.config/nvim/sonido-lang/js.lua
```lua
return {
  angle_l = {},
  assign_r = {},
  ...
}
```

and import it to init.lua so that it's easy to adjust settings reagardless of number of languages

##### init.lua
```lua
    config = function()
        local js = require('sonido-lang.js')

        require("sonido").setup({
            langs = { 'js', 'jsx', 'cpp' },
            keymaps = { 
              user_defined_custom_symbol = {
                '<Leader>P', '<Leader>p'
              },          
            },
            symbols = {
              js = js,
              jsx = js,
              cpp = require("sonido-lang.cpp"),
            }
        })
    end
```
