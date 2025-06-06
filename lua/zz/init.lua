---@class ZModeConfig
---@field notify? boolean Whether to notify on mode changes
---@field mappings table<string, string> Key mappings for different z-modes
---@field integrations { whichkey?: { group?: { icon?: string, prefix?: string, name?: string } }, snacks?: boolean } Optional integrations

---@class ZMode
---@field setup fun(opts?: ZModeConfig) Configure the plugin
---@field disable fun() Disable current z-mode
---@field set_mode fun(mode?: string) Set current z-mode
---@field is_enabled fun(mode: string): boolean Check if specific mode is enabled
-- Module state
local valid_modes = {
  zz = {},
  zt = {},
  zb = {},
}

local M = {}

---@type ZModeConfig
M.config = {
  notify = true,
  mappings = {
    zz = "<leader>zz",
    zt = "<leader>zt",
    zb = "<leader>zb",
  },
  integrations = {
    whichkey = {
      group = {
        icon = "󰬡",
        prefix = "<leader>z",
        name = " ZZ modes",
      },
    },
    snacks = true,
  },
}

-- Private functions
local function sanitize()
  if valid_modes[vim.g.zz_mode] == nil and vim.g.zz_mode ~= "" then
    vim.notify("Invalid mode: '" .. vim.g.zz_mode .. "'", vim.log.levels.WARN)
    M.disable()
  end
end

local function setup_cursor_moved()
  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
      local current_line = vim.fn.line(".")
      local prev_line = vim.b.last_line or current_line

      vim.b.last_line = current_line

      if current_line ~= prev_line and vim.g.zz_mode and vim.g.zz_mode ~= "" then
        vim.cmd("normal! " .. vim.g.zz_mode)
      end
    end,
    desc = "Auto-center based on vim.g.zz_mode",
  })
end

local function whichkey_available()
  local ok, _ = pcall(require, "which-key")
  return ok
end

local function register_whichkey()
  local wk = M.config.integrations.whichkey
  if wk == nil then
    return
  end

  if wk.group == nil then
    return
  end

  if not whichkey_available() then
    return
  end

  -- Create the group registrations
  require("which-key").add({
    {
      wk.group.prefix,
      group = wk.group.name,
      icon = wk.group.icon,
    },
  })
end

local function setup_mode_toggle(mode)
  local snacks_toggle = {
    id = mode .. "_mode",
    name = mode .. " mode",
    get = function()
      return M.is_enabled(mode)
    end,
    set = function(state)
      M.set_mode(state and mode or "")
    end,
    notify = M.config.notify,
  }

  local mapping = M.config.mappings[mode] or ("<leader>" .. mode)

  -- Set up Snacks integration if available and enabled
  local snacks = M.config.integrations.snacks
  if snacks ~= nil and snacks then
    Snacks.toggle.new(snacks_toggle):map(mapping)
  else
    -- fallback to "manual" toggle function
    local toggle_func = function()
      M.set_mode(M.is_enabled(mode) and "" or mode)
      local state = "Off"
      if vim.g.zz_mode == mode then
        state = "On"
      end
      if M.config.notify then
        vim.notify(mode .. " mode turned " .. state, vim.log.levels.INFO)
      end
    end

    local desc = "Toggle " .. mode .. " mode"
    vim.keymap.set("n", mapping, toggle_func, { desc = desc })
  end
end

-- Public API
---@param opts? ZModeConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.schedule(function()
    sanitize()
    setup_cursor_moved()
    register_whichkey()

    -- Set up toggles for each mode
    for mode, _ in pairs(valid_modes) do
      setup_mode_toggle(mode)
    end
  end)
end

function M.disable()
  vim.g.zz_mode = ""
end

---Set the current mode
---@param mode? string The mode to set
function M.set_mode(mode)
  vim.g.zz_mode = mode or ""
  sanitize()
end

---Check if a specific mode is enabled
---@param mode string The mode to check
---@return boolean
function M.is_enabled(mode)
  return vim.g.zz_mode == mode
end

return M
