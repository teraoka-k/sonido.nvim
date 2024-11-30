# Sonído

## Abstract

As [bleach.fandom.com](https://bleach.fandom.com/wiki/Son%C3%ADdo) says, 

> Sonído (響転ソニード, Sonīdo; Spanish for "Sound", Japanese for "Reverberating Turn") is a high-speed movement technique utilized by Hollows and Arrancar. It is equivalent to the Shinigami's Shunpo and the Quincy's Hirenkyaku, which are roughly equal in terms of speed. 

This plugin does that for Vim

## Install

Add this to init.lua

```.lua
{
  dir = "path-to-this-repo", 
  name = "sonido",
  config = function ()
    require('sonido').setup()
  end
}
```