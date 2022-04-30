MAIN.configurations["fterm"] = {
  plugin_setup_params = {
    border = "none",
    cmd = os.getenv("SHELL"),
    auto_close = true,
    hl = "Normal",
    blend = 0,
    dimensions = {height = 1, width = 1, x = 0, y = 0}
  },
  keymappings = {
    {
      mappings = {
        ["<F7>"] = {"<cmd>lua require'FTerm'.toggle()<cr>", "Explorer"}
      },
      options = {
        mode = "n",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true
      }
    },
    {
      mappings = {
        ["<F7>"] = {"<cmd>lua require'FTerm'.toggle()<cr>", "Explorer"}
      },
      options = {
        mode = "t",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true
      }
    }
  },
  packer_module = {
    config = function()
      local fterm = require "FTerm"
      local c = MAIN.configurations["fterm"]
      fterm.setup(c.plugin_setup_params)
      MAIN.which_key.compile(c.keymappings)
    end
  }
}
MAIN.packer.append {
  ["numtostr/FTerm.nvim"] = MAIN.must_require("FTerm", "fterm").packer_module
}
