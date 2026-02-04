# nvim-invert

A simple plugin for automatically toggling the background of Vim. I've tested it when using the EverForest theme. If your session's background is `dark` it will set it to `light` and vice-versa.

## Installation

### When Using LazyVim

For default configuration and options, you can just create a new plugin file and then paste these contents.

```sh
cd ~/.config/nvim/lua/plugins/; #Assuming default installation directory.
touch invert.lua; #Any name here will work.
```

```lua
return {
  {
    "zacharyFerretti/nvim-invert",
    opts = {
      keymap = "<leader>ut",
      persist = true,
    },
  },
}
```

Then you just have to open nvim - and run `:Lazy sync`.

## Usage

1. To invoke it via a hot-key, simply use `<leader>ut`.
2. To invoke it via a command, use `:Invert`.
