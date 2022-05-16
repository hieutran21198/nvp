local packer = require "common.packer"

local M = {
  keymappings = {}
}

packer.register {
  ["folke/which-key.nvim"] = {
    config = function()
      local ok, which_key = pcall(require, "which-key")
      if not ok then
        return
      end
      which_key.setup(
        {
          plugins = {
            marks = true,
            registers = true,
            presets = {
              operators = true,
              motions = true,
              text_objects = false,
              window = true,
              nav = true,
              z = true,
              g = true
            },
            spelling = {enabled = true, suggestions = 20}
          },
          icons = {breadcrumb = "»", separator = "➜", group = "+"},
          window = {
            border = "none",
            position = "bottom",
            margin = {1, 0, 1, 0},
            padding = {2, 2, 2, 2}
          },
          layout = {
            height = {min = 4, max = 25},
            width = {min = 20, max = 50},
            spacing = 3
          },
          popup_mappings = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>" -- binding to scroll up inside the popup
          },
          triggers = "auto",
          hidden = {
            "<silent>",
            "<cmd>",
            "<Cmd>",
            "<CR>",
            "call",
            "lua",
            "^:",
            "^ "
          },
          show_help = true
        }
      )
    end
  }
}

---@param mappings table
---@param options table
M.store = function(mappings, options)
  table.insert(
    M.keymappings,
    {
      mappings = mappings,
      options = options
    }
  )
end

---@param keymappings table | nil
M.compile = function(keymappings, debug)
  if keymappings == nil then
    keymappings = M.keymappings
  end
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  if debug ~= nil and debug == true then
    print(vim.inspect(keymappings))
  end

  for _, group in ipairs(keymappings) do
    if group.options == nil then
      group.options = {
        mode = "n",
        silent = true,
        noremap = true,
        nowait = true
      }
    end
    wk.register(group.mappings, group.options)
  end
end

---@param mappings table
---@param options table
M.compile_with_options = function(mappings, options)
  M.compile {
    {
      mappings = mappings,
      options = options
    }
  }
end

return M
