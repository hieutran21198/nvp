local packer = require "common.packer"

local M = {
  keymappings = {}
}

packer.append {
  ["folke/which-key.nvim"] = {
    config = function()
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
M.compile = function(keymappings)
  if keymappings == nil then
    keymappings = M.keymappings
  end
  local wk = require "which-key"
  for _, group in ipairs(keymappings) do
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
