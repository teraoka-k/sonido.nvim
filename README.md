# Sonído

## Abstract

Sonído is **a high-speed movement technique** as [bleach.fandom.com](https://bleach.fandom.com/wiki/Son%C3%ADdo) says

> Sonído (響転ソニード, Sonīdo; Spanish for "Sound", Japanese for "Reverberating Turn") is a high-speed movement technique utilized by Hollows and Arrancar. It is equivalent to the Shinigami's Shunpo and the Quincy's Hirenkyaku, which are roughly equal in terms of speed. 

Sonído.nvim is a high-speed movement technique utilized by Vimmers.


- **move to a word immediately**
  - `f {char1} {char2} {char3}` 
  - `s {char1} {char2}`
  - `t {char}`
  - `+Shift` **backwards**
- **jump to symbols**
  - `]` next 
  - `[` prev
    - *.rs: `fn struct impl trait`
    - *.md: `# ## ### #### ...`
    - *: `function`
- **Repeat ANY movement of Sonído**
  - `;` next (next matched chars, or next code blocks)
  - `,` prev

Sonído and [easymotion](https://github.com/easymotion/vim-easymotion) are different, as 
- Sonído incorporates Vim's default **`;` `,` behaviour**, which adds **extra ease** to navigation
- Sonído **does not display labels**, instead lets you type exactly the first 2 or 3 letters of a word, then **immediately move to the word**, hence it's more easy to use for those who are not good at "spot the difference" type UX like me.

That's why I created this plugin

## Motivation
I'm **not good at using easy-motion**. Recognizing a randomly generated letter **requires a bit time as it's hidden before typing**. I rather feel comfortable **focusing to a visible symbols in the editor** and typing the first two or three letters to **move the cursor immediately**. And I'm happy if **Vim remembers my typings** and move to next or previous matches with **`;` and `,` in the same way as `f` and `t`**. 

## Install

### lazy.nvim
```.lua
{
    "teraoka-k/sonido.nvim",
    config = function()
        require("sonido").setup()
    end
}
```

## Edit Keybindings


### lazy.nvim
```.lua
{
    "teraoka-k/sonido.nvim",
    config = function()
        local M = require("sonido")
        -- move to matched chars
        vim.keymap.set('n', 'f', function() M.char_next(3) end)
        vim.keymap.set('n', 'F', function() M.char_prev(3) end)
        vim.keymap.set('n', 's', function() M.char_next(2) end)
        vim.keymap.set('n', 'S', function() M.char_prev(2) end)
        vim.keymap.set('n', 't', function() M.char_next(1) end)
        vim.keymap.set('n', 'T', function() M.char_prev(1) end)

        -- move to symbols (language specific semantics)
        vim.keymap.set('n', ']', M.symbol_next)
        vim.keymap.set('n', '[', M.symbol_prev)
        -- to move to symbols immediately
        M.unmap_all(
          { '[', ']' }, -- if keymaps starting with `[` or `]`
          { 'n' }, -- and in normal mode
          1  -- and whose length is larger than 1
        )

        -- repeat move
        vim.keymap.set('n', ';', M.next)
        vim.keymap.set('n', ',', M.prev)
    end
}
```

## Extension

- move by **any number of chars**
- unmap any keys
- set offset when moving to matched char like Vim's default `t` key, and **any length of offset** can be used

```.lua
{
    "teraoka-k/sonido.nvim",
    config = function()
        local s = require("sonido")
        s.setup()
        local km = vim.keymap
          
        -- ======== type 5 chars ============
        km.set('n', 'f', function() s.search_forward(5) end)
        km.set('n', 'F', function() s.search_backward(5) end)

        -- ======== equal to Vim's default t =========
        local offset = -1
        km.set('n', 't', function() s.to_char(1, false, true, offset) end)

        -- ======== very useful by itself===============
        -- unmap all keymaps of g in normal & visual
        M.unmap_all( { 'g' }, { 'n', 'v' }, 0)
    end
}
```

## Limitation

- **not be able to cancel the command with \<Esc>**. **PR is welcome** from anyone, just open issue for that. I appreciate your support to handle \<Esc> key correctly with Vim's built-in function `getchar`
- only if you use **"VS-Code neovim"**, then **\<Space> key cannot be used** as a search charcter, again anyone please let me know if you find a way to work it out in VS-Code