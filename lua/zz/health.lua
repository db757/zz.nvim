local M = {}

local health = vim.health or require("health")

function M.check()
  health.start("zz.nvim")

  -- Check for optional dependencies
  health.info("Checking optional dependencies...")

  local has_whichkey = pcall(require, "which-key")
  if has_whichkey then
    health.ok("which-key.nvim is installed")
  else
    health.info("which-key.nvim is not installed (optional)")
  end

  local has_snacks = pcall(require, "snacks")
  if has_snacks then
    health.ok("snacks.nvim is installed")
  else
    health.info("snacks.nvim is not installed (optional)")
  end

  -- Check if modes are properly registered
  health.info("Checking z-modes...")
  local valid_modes = { "zz", "zt", "zb" }
  for _, mode in ipairs(valid_modes) do
    if require("zz").config.mappings[mode] then
      health.ok(string.format("%s mode is properly configured with mapping: %s",
        mode, require("zz").config.mappings[mode]))
    else
      health.warn(string.format("%s mode is missing mapping configuration", mode))
    end
  end

  -- Check global state
  health.info("Checking plugin state...")
  if vim.g.zz_mode ~= nil then
    if vim.g.zz_mode == "" then
      health.ok("Plugin is initialized with no active mode")
    else
      health.ok(string.format("Plugin is initialized with active mode: %s", vim.g.zz_mode))
    end
  else
    health.error("Plugin state is not initialized")
  end

  -- Check autocmd registration
  health.info("Checking autocmds...")
  local found = false
  for _, autocmd in ipairs(vim.api.nvim_get_autocmds({event = "CursorMoved"})) do
    if autocmd.desc and autocmd.desc:match("Auto%-center based on vim%.g%.zz_mode") then
      found = true
      break
    end
  end

  if found then
    health.ok("CursorMoved autocmd is properly registered")
  else
    health.error("CursorMoved autocmd is not registered")
  end
end

return M
