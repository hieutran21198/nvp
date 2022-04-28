local M = {
  plugins = {}
}

--- Append new plugins to the list of plugins
---@param plugins table
M.append = function(plugins)
  if type(plugins) == "table" then
    for k, v in pairs(plugins) do
      if type(k) == "number" and type(v) == "string" then
        table.insert(
          M.plugins,
          v
        )
      elseif type(k) == "string" and type(v) == "table" then
        local plugin = {k}
        for method, value in pairs(v) do
          plugin[method] = value
        end
        table.insert(M.plugins, plugin)
      end
    end
  end
end

M.provision = function()
  local gpacker = "https://github.com/wbthomason/packer.nvim"
  if vim.fn.empty(vim.fn.glob(vim.env.HOME .. "/.local/share/nvim/site/pack/packer/start/packer.nvim")) > 0 then
    local cmd = "!git clone " .. gpacker .. " ~/.local/share/nvim/site/pack/packer/start/packer.nvim"
    vim.api.nvim_command(cmd)
    vim.api.nvim_command("packadd packer.nvim")
  end
  local ok, packer = pcall(require, "packer")
  if not ok then
    return
  end
  local packer_utils = require "packer.util"
  packer.init {
    package_root = vim.env.HOME .. "/.local/share/nvim/site/pack",
    compile_path = vim.env.HOME .. "/.local/share/nvim/plugin/packer_compiled.lua",
    display = {
      open_fn = function()
        return packer_utils.float {border = "rounded"}
      end
    }
  }
end

M.startup = function()
  local ok, packer = pcall(require, "packer")
  if not ok then
    return
  end
  packer.startup(
    function(use)
      use "wbthomason/packer.nvim"
      for _, plug in ipairs(M.plugins) do
        use(plug)
      end
    end
  )
end

return M
