# zz.nvim

A Neovim plugin that provides automatic buffer centering modes (zz, zt, zb) with configurable keybindings.

## Features

- Automatic buffer centering when moving vertically
- Multiple centering modes (zz, zt, zb)
- Configurable keybindings
- Optional integration with which-key and Snacks.toggle

## Dependencies

### Required

- Neovim >= 0.8.0

### Optional

- [which-key.nvim](https://github.com/folke/which-key.nvim) - For enhanced key binding documentation
- [snacks.nvim](https://github.com/folke/snacks.nvim) - For enhanced toggle functionality and state management

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "db757/zz.nvim",
  dependencies = {
    -- Optional dependencies
    "folke/which-key.nvim",
    "folke/snacks.nvim",
  },
  -- Optional configuration (plugin auto-initializes with defaults)
  opts = {
    -- your configuration
  },
}
```

## Configuration

The plugin auto-initializes with default settings. You can optionally customize it:

```lua
require("zz").setup({
  -- Key mappings for different modes
  mappings = {
    zz = "<leader>zz", -- Center current line
    zt = "<leader>zt", -- Top align current line
    zb = "<leader>zb", -- Bottom align current line
  },
  -- Optional integrations (all enabled by default)
  integrations = {
    whichkey = true, -- Enable which-key integration
    snacks = true,   -- Enable Snacks.toggle integration
  },
})
```

## API

### Functions

```lua
-- Configure the plugin
zz.setup(opts?: ZModeConfig)

-- Disable current mode
zz.disable()

-- Set current mode
zz.set_mode(mode?: string)

-- Check if specific mode is enabled
zz.is_enabled(mode: string): boolean

-- You can also control the mode by setting vim.g.zz_mode directly:
vim.g.zz_mode = "zz"  -- Center mode
vim.g.zz_mode = "zt"  -- Top mode
vim.g.zz_mode = "zb"  -- Bottom mode
vim.g.zz_mode = ""    -- Disable mode
```

### Types

```lua
---@class ZModeConfig
---@field mappings table<string, string> Key mappings for different z-modes
---@field integrations { whichkey?: boolean, snacks?: boolean } Optional integrations

---@class ZMode
---@field setup fun(opts?: ZModeConfig) Configure the plugin
---@field disable fun() Disable current z-mode
---@field set_mode fun(mode?: string) Set current z-mode
---@field is_enabled fun(mode: string): boolean Check if specific mode is enabled
---@field config ZModeConfig
```

## Health Checks

Run `:checkhealth zz` to verify your setup and check dependencies.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
