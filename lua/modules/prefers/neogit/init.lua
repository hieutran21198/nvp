MAIN.configurations["neogit"] = {
  packer_module = {
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      local neogit = require "neogit"
      local c = MAIN.configurations["neogit"]
      neogit.setup(c.plugin_setup_params)
      MAIN.which_key.compile(c.key_mappings)
    end
  },
  key_mappings = {
    {
      mappings = {
        ["<leader>"] = {
          gn = {"<cmd>Neogit<cr>", "Open Neogit"}
        }
      }
    }
  },
  plugin_setup_params = {
    disable_signs = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = false,
    -- customize displayed signs
    signs = {
      -- { CLOSED, OPENED }
      section = {">", "v"},
      item = {">", "v"},
      hunk = {"", ""}
    },
    integrations = {diffview = true},
    -- override/add mappings
    mappings = {
      -- modify status buffer mappings
      status = {}
    }
  }
}

MAIN.packer.register {
  ["TimUntersberger/neogit"] = MAIN.must_require("neogit", "neogit").packer_module
}
