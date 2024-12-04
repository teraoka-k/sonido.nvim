# Sonído

## Abstract

Sonído is **a high-speed movement technique** as [bleach.fandom.com](https://bleach.fandom.com/wiki/Son%C3%ADdo) says

> Sonído (響転 (ソニード), Sonīdo; Spanish for "Sound", Japanese for "Reverberating Turn") is a high-speed movement technique utilized by Hollows and Arrancar. It is equivalent to the Shinigami's Shunpo and the Quincy's Hirenkyaku, which are roughly equal in terms of speed. 

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
- **Repeat ANY movement**
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
    config = function() require("sonido").setup() end
}
```

## Edit Keybindings


### lazy.nvim
```.lua
{
    "teraoka-k/sonido.nvim",
    config = function() require("sonido").setup({
      lua = {
        fn = { '<Leader>k', '<Leader>j' }
      }
    }) end
}
```

## Limitation
- Non-English litters are not supported as lua's `string.find` function does not work for other languages
  - hence, lines that include words like `Sonído` and `響転 (ソニード)` cannot be searched correctly