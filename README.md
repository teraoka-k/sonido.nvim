# Sonído

## Abstract

Sonido is **a movement technique** of Arrancar, as [bleach.fandom.com](https://bleach.fandom.com/wiki/Son%C3%ADdo) says

> Sonído (響転ソニード, Sonīdo; Spanish for "Sound", Japanese for "Reverberating Turn") is a high-speed movement technique utilized by Hollows and Arrancar. It is equivalent to the Shinigami's Shunpo and the Quincy's Hirenkyaku, which are roughly equal in terms of speed. 

Sonido.nvim is a movement technique for nvim.

- **move to a word immediately**
  - `f {char1} {char2} {char3}` 
  - `s {char1} {char2}`
  - `t {char}`
  - `+Shift` **backwards**
- **cycle through matched words**
  - `;` next
  - `,` prev

Sonido.nvim and [easymotion](https://github.com/easymotion/vim-easymotion) are different, as 
- the former incorporates Vim's default **`;` `,` behaviour**, which adds **extra ease** to navigation
- the former **does not display labels**, instead lets you type exactly the first 2 or 3 letters of a word, then **immediately move to the word**, hence it's more easy to use for those who are not good at "spot the difference" type UX like me.

That's why I created this plugin

## Motivation
Using easy-motion, I'm **not good at picking a correct label**. Recognizing a randomly generated letter **requires a bit concentration** for me. I rather feel comfortable **just focusing to a symbol in code** and typing the first two or three letters of that word to **move there immediately**. And I'm happy if **Vim remembers my typings** and move to next or previous matches with **`;` and `,` in the same way as `f` and `t`**, which is helpful if there are multiple matches. With this plugin, all of them can be achieved.

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
        local s = require("sonido")
        local km = vim.keymap
        km.set('n', 'f', function() s.search_forward(3) end)
        km.set('n', 'F', function() s.search_backward(3) end)
        km.set('n', 's', function() s.search_forward(2) end)
        km.set('n', 'S', function() s.search_backward(2) end)
        km.set('n', 't', function() s.search_forward(1) end)
        km.set('n', 'T', function() s.search_backward(1) end)
        km.set('n', ';', function() s.go_next() end)
        km.set('n', ',', function() s.go_prev() end)
    end
}
```

## Extension

you can use **any number of chars** to move to

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

    end
}
```

## Limitation

- **not be able to cancel the command with \<Esc>**. **PR is welcome** from anyone, just open issue for that. I appreciate your support to handle \<Esc> key correctly with Vim's built-in function `getchar`
- only if you use **"VS-Code neovim"**, then **\<Space> key cannot be used** as a search charcter, again anyone please let me know if you find a way to work it out in VS-Code