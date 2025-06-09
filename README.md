# zz.nvim

A Neovim plugin that provides automatic buffer centering modes (zz, zt, zb) with configurable keybindings.

## Features

- Automatic buffer centering when moving vertically
- Multiple centering modes (zz, zt, zb)
- Buffer-local settings for per-buffer centering behavior
- Configurable keybindings with global and buffer-local mappings
- Optional integration with which-key and Snacks.toggle
- Filetype-specific ignore settings

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
    -- Global mode mappings
    zz = "<leader>zz", -- Center current line
    zt = "<leader>zt", -- Top align current line
    zb = "<leader>zb", -- Bottom align current line

    -- Buffer-local mappings (override global setting for current buffer)
    bzz = "<leader>zZ", -- Toggle buffer-local center mode
    bzt = "<leader>zT", -- Toggle buffer-local top mode
    bzb = "<leader>zB", -- Toggle buffer-local bottom mode
    bzc = "<leader>zC", -- Clear buffer-local mode (use global)
  },
  -- Optional integrations
  integrations = {
    whichkey = {
      enabled = true,
      group = {
        icon = "󰬡",  -- Icon for the group
        prefix = "<leader>z",
        name = " ZZ modes"
      }
    },
    snacks = true,   -- Enable Snacks.toggle integration
  },
  -- Filetypes to ignore for auto-centering (these are the defaults)
  ignore_filetypes = {
    ["help"] = false,
    ["qf"] = false,
    ["TelescopePrompt"] = true,
    ["NvimTree"] = true,
    ["Trouble"] = true,
    ["lazy"] = true,
    ["mason"] = true,
    ["oil"] = true,
    ["copilot-chat"] = true,
  },
  },
})
```

## API

### Functions

```lua
zz = require("zz")

-- Configure the plugin
zz.setup(opts?: ZModeConfig)

-- Disable current mode
zz.disable()

-- Set current mode
zz.set_mode(mode?: string)

-- Check if specific mode is enabled
zz.is_enabled(mode: string): boolean

-- Global mode control:
vim.g.zz_mode = "zz"  -- Center mode
vim.g.zz_mode = "zt"  -- Top mode
vim.g.zz_mode = "zb"  -- Bottom mode
vim.g.zz_mode = ""    -- Disable mode

-- Buffer-local mode control:
vim.b.zz_mode = "zz"  -- Buffer-local center mode
vim.b.zz_mode = "zt"  -- Buffer-local top mode
vim.b.zz_mode = "zb"  -- Buffer-local bottom mode
vim.b.zz_mode = ""    -- Clear buffer-local mode
vim.b.zz_mode = nil   -- Remove buffer-local setting (use global)
```

### Types

```lua
---@class ZModeConfig
---@field notify? boolean Whether to notify when the mode changes
---@field mappings table<string, string> Key mappings for different z-modes
---@field integrations {
---    whichkey?: {
---      group?: {
---        icon?: string,
---        prefix?: string,
---        name?: string
---      }
---    },
---    snacks?: boolean
---  } Optional integrations
---@field ignore_filetypes? table<string, bool> List of filetypes to ignore

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
